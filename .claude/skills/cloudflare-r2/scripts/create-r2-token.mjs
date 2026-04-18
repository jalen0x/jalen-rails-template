import { createHash, randomBytes } from 'node:crypto';
import { execSync } from 'node:child_process';
import { writeFileSync, unlinkSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseArgs } from 'node:util';

const ALLOWED_ENVS = ['production', 'staging', 'development'];

const scriptDir = dirname(fileURLToPath(import.meta.url));
const projectDir = resolve(scriptDir, '../../../..');

const { values } = parseArgs({
  options: {
    bucket: { type: 'string' },
    account: { type: 'string' },
    env: { type: 'string' },
    'cdn-host': { type: 'string' },
    help: { type: 'boolean', short: 'h' },
  },
  strict: true,
});

if (values.help || !values.bucket || !values.account || !values.env) {
  console.error('Usage: node create-r2-token.mjs --bucket <name> --account <id> --env <environment> [--cdn-host https://cdn.example.com]');
  console.error('Requires env: CLOUDFLARE_API_KEY + CLOUDFLARE_EMAIL');
  process.exit(values.help ? 0 : 1);
}

if (!ALLOWED_ENVS.includes(values.env)) {
  console.error(`错误: --env 必须是 ${ALLOWED_ENVS.join(' / ')}`);
  process.exit(1);
}

const { bucket: bucketName, account: accountId, env } = values;
const cdnHost = values['cdn-host'];
const useAccountToken = env === 'production';

let Cloudflare;
try {
  ({ default: Cloudflare } = await import('cloudflare'));
} catch {
  const globalRoot = execSync('npm root -g', { encoding: 'utf-8' }).trim();
  if (!/^\/[\w./@-]+$/.test(globalRoot)) {
    console.error(`Unexpected npm root path: ${globalRoot}`);
    process.exit(1);
  }
  ({ default: Cloudflare } = await import(`${globalRoot}/cloudflare/index.mjs`));
}
const client = new Cloudflare();

const tokenName = `${bucketName}-r2-token`;
const bucketResource = `com.cloudflare.edge.r2.bucket.${accountId}_default_${bucketName}`;

let listPerms, createToken;

if (useAccountToken) {
  console.log(`\x1b[36m[Account Token] production 环境使用 Account API Token\x1b[0m`);
  listPerms = () => client.accounts.tokens.permissionGroups.list({ account_id: accountId });
  createToken = (params) => client.accounts.tokens.create({ ...params, account_id: accountId });
} else {
  console.log(`\x1b[36m[User Token] ${env} 环境使用 User API Token\x1b[0m`);
  listPerms = () => client.user.tokens.permissionGroups.list();
  createToken = (params) => client.user.tokens.create(params);
}

const pg = await listPerms();
const permGroups = pg.result || pg;

const r2Write = permGroups.find(g => g.name?.includes('Bucket Item') && g.name?.includes('Write'));
const r2Read = permGroups.find(g => g.name?.includes('Bucket Item') && g.name?.includes('Read'));
if (!r2Write || !r2Read) { console.error('R2 Bucket Item permission groups not found'); process.exit(1); }

const tokenResp = await createToken({
  name: tokenName,
  policies: [{
    effect: 'allow',
    permission_groups: [{ id: r2Write.id }, { id: r2Read.id }],
    resources: { [bucketResource]: '*' }
  }]
});

const token = tokenResp?.result ?? tokenResp;
if (
  !token ||
  typeof token !== 'object' ||
  typeof token.id !== 'string' ||
  token.id.length === 0 ||
  typeof token.value !== 'string' ||
  token.value.length === 0
) {
  // Cloudflare only returns token.value at creation time; if we don't have it now, we cannot proceed.
  const idType = token && typeof token === 'object' ? typeof token.id : typeof token;
  const valueType = token && typeof token === 'object' ? typeof token.value : typeof token;
  console.error('Error: Cloudflare API response did not include a usable token.id and token.value; cannot generate secret_access_key.');
  console.error(`Observed token.id type: ${idType}, token.value type: ${valueType}`);
  process.exit(1);
}

const accessKeyId = token.id;
// R2 S3 API requires secret_access_key to be the SHA-256 hex digest of token.value.
// Applies to both /user/tokens (User API Token) and /accounts/:id/tokens (generic
// Account Token). If we ever switch to R2 bucket-scoped tokens
// (/accounts/:id/r2/buckets/:bucket/tokens), that endpoint returns an already-usable
// secretAccessKey — do not hash it again.
// Ref: https://developers.cloudflare.com/r2/api/tokens/
const secretAccessKey = createHash('sha256').update(token.value).digest('hex');
const cdnSecret = randomBytes(32).toString('hex');

function mask(s) { return s.slice(0, 8) + '…' + s.slice(-4); }

const summary = {
  token_type: useAccountToken ? 'Account' : 'User',
  access_key_id: accessKeyId,
  secret_access_key: mask(secretAccessKey),
  bucket_name: bucketName,
  endpoint: `https://${accountId}.r2.cloudflarestorage.com`,
  cdn_secret: mask(cdnSecret),
};
if (cdnHost) summary.cdn_host = cdnHost;

console.log(JSON.stringify(summary, null, 2));

const updates = {
  cloudflare: {
    account_id: accountId,
    r2: {
      access_key_id: accessKeyId,
      secret_access_key: secretAccessKey,
      bucket_name: bucketName,
      cdn_secret: cdnSecret,
    }
  }
};
if (cdnHost) updates.cloudflare.r2.cdn_host = cdnHost;

saveToCredentials(env, updates, projectDir);

function saveToCredentials(env, updates, projectDir) {
  const tmpScript = resolve(projectDir, 'tmp', 'update-credentials.rb');
  writeFileSync(tmpScript, [
    'require "yaml"',
    'require "json"',
    'path = ARGV[0]',
    'yaml = YAML.safe_load(File.read(path)) || {}',
    'updates = JSON.parse(ENV.fetch("CRED_UPDATES"))',
    'def deep_merge(h1, h2)',
    '  h1.merge(h2) { |_k, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? deep_merge(v1, v2) : v2 }',
    'end',
    'File.write(path, YAML.dump(deep_merge(yaml, updates)))',
  ].join("\n") + "\n");

  console.log(`\n==> 保存到 Rails credentials (${env})...`);
  try {
    execSync(`EDITOR="ruby '${tmpScript}'" bin/rails credentials:edit -e ${env}`, {
      cwd: projectDir,
      stdio: 'inherit',
      env: { ...process.env, CRED_UPDATES: JSON.stringify(updates) }
    });
    console.log('==> 已保存到 credentials');
  } finally {
    try { unlinkSync(tmpScript); } catch {}
  }
}
