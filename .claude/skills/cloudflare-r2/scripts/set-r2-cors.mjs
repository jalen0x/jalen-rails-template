import { execSync } from 'node:child_process';
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { resolve } from 'node:path';
import { parseArgs } from 'node:util';

const DEFAULT_METHODS = 'GET,PUT,POST,HEAD';
const DEFAULT_MAX_AGE = 3600;
const DEFAULT_EXPOSE_HEADERS = ['ETag', 'Content-Length'];

const { values } = parseArgs({
  options: {
    bucket: { type: 'string' },
    origins: { type: 'string' },
    methods: { type: 'string' },
    'max-age': { type: 'string' },
    help: { type: 'boolean', short: 'h' },
  },
  strict: true,
});

if (values.help || !values.bucket || !values.origins) {
  console.error('Usage: node set-r2-cors.mjs --bucket <name> --origins <url1,url2,...> [--methods GET,PUT,POST,HEAD] [--max-age 3600]');
  console.error('Requires: wrangler CLI authenticated');
  process.exit(values.help ? 0 : 1);
}

const bucket = values.bucket;
const origins = values.origins.split(',').map(s => s.trim()).filter(Boolean);
const methods = (values.methods || DEFAULT_METHODS).split(',').map(s => s.trim()).filter(Boolean);
const maxAge = Number.parseInt(values['max-age'] ?? String(DEFAULT_MAX_AGE), 10);

if (origins.length === 0) { console.error('Error: --origins must contain at least one URL'); process.exit(1); }
if (methods.length === 0) { console.error('Error: --methods must contain at least one method'); process.exit(1); }
if (!Number.isFinite(maxAge) || maxAge < 0) { console.error(`Error: --max-age must be a non-negative integer, got ${values['max-age']}`); process.exit(1); }

// Cloudflare R2 CORS schema: https://developers.cloudflare.com/api/operations/r2-put-bucket-cors-policy
// Note the `rules` wrapper + camelCase keys — this is NOT the S3 PascalCase format.
const corsPolicy = {
  rules: [{
    allowed: { origins, methods, headers: ['*'] },
    exposeHeaders: DEFAULT_EXPOSE_HEADERS,
    maxAgeSeconds: maxAge,
  }],
};

const tmpDir = mkdtempSync(resolve(tmpdir(), 'r2-cors-'));
const tmpFile = resolve(tmpDir, `${bucket}-cors.json`);
writeFileSync(tmpFile, JSON.stringify(corsPolicy, null, 2));

try {
  console.log(`\x1b[36m==> Applying CORS to ${bucket}...\x1b[0m`);
  console.log(`    origins: ${origins.join(', ')}`);
  console.log(`    methods: ${methods.join(', ')}`);
  console.log(`    max-age: ${maxAge}s`);
  execSync(`wrangler r2 bucket cors set ${bucket} --file ${tmpFile} -y`, { stdio: 'inherit' });
  console.log(`\n\x1b[36m==> Current CORS on ${bucket}:\x1b[0m`);
  execSync(`wrangler r2 bucket cors list ${bucket}`, { stdio: 'inherit' });
} finally {
  rmSync(tmpDir, { recursive: true, force: true });
}
