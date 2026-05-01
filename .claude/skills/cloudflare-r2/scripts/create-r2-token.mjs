import { createHash, randomBytes } from 'node:crypto';
import { execSync } from 'node:child_process';
import { parseArgs } from 'node:util';

const ALLOWED_ENVS = ['production', 'staging', 'development'];

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

const envValues = {
  CLOUDFLARE_ACCOUNT_ID: accountId,
  R2_ACCESS_KEY_ID: accessKeyId,
  R2_SECRET_ACCESS_KEY: secretAccessKey,
  R2_BUCKET_NAME: bucketName,
  R2_CDN_SECRET: cdnSecret,
};
if (cdnHost) envValues.R2_CDN_HOST = cdnHost;

printEnvValues(env, envValues);

function printEnvValues(env, values) {
  console.log(`\n==> Add these ${env} ENV values to your secret manager / Kamal secrets:`);
  for (const [key, value] of Object.entries(values)) {
    console.log(`${key}=${value}`);
  }
}
