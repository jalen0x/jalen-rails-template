#!/usr/bin/env node

const CF_BASE = "https://api.cloudflare.com/client/v4";
const NS_BASE = "https://www.namesilo.com/api";

const C = {
  reset: "\x1b[0m",
  bold: "\x1b[1m",
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  cyan: "\x1b[36m",
  dim: "\x1b[2m",
};

function log(msg) { console.log(msg); }
function ok(msg) { log(`${C.green}✓${C.reset} ${msg}`); }
function warn(msg) { log(`${C.yellow}⚠${C.reset} ${msg}`); }
function fail(msg) { log(`${C.red}✗${C.reset} ${msg}`); }
function heading(msg) { log(`\n${C.bold}${C.cyan}${msg}${C.reset}`); }

function requireEnv(name) {
  const val = process.env[name];
  if (!val) { fail(`Missing environment variable: ${name}`); process.exit(1); }
  return val;
}

async function cfReq(method, path, body) {
  const res = await fetch(`${CF_BASE}${path}`, {
    method,
    headers: {
      "X-Auth-Key": requireEnv("CLOUDFLARE_API_KEY"),
      "X-Auth-Email": requireEnv("CLOUDFLARE_EMAIL"),
      "Content-Type": "application/json",
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const data = await res.json();
  if (!data.success) {
    const errors = (data.errors || []).map((e) => `${e.code}: ${e.message}`).join(", ");
    const messages = (data.messages || []).map((m) => m.message).join(", ");
    fail(`Cloudflare ${method} ${path} (${res.status}): ${errors || messages || JSON.stringify(data)}`);
    process.exit(1);
  }
  return data;
}

async function getAccountId() {
  const data = await cfReq("GET", "/accounts?page=1&per_page=5");
  const account = data.result[0];
  if (!account) { fail("No Cloudflare account found"); process.exit(1); }
  ok(`Account: ${account.name} (${account.id})`);
  return account.id;
}

async function nsReq(command, params = {}) {
  const key = requireEnv("NAMESILO_API_KEY");
  const query = new URLSearchParams({ version: "1", type: "json", key, ...params });
  const url = `${NS_BASE}/${command}?${query}`;
  const res = await fetch(url);
  const data = await res.json();
  const reply = data.reply;
  const code = reply?.code || reply?.detail;
  if (code && String(code) !== "300" && String(code) !== "302") {
    fail(`NameSilo ${command}: ${reply.detail} (code: ${code})`);
    process.exit(1);
  }
  return reply;
}

async function addCloudflareZone(domain) {
  heading(`Adding zone to Cloudflare: ${domain}`);
  const accountId = await getAccountId();
  const data = await cfReq("POST", "/zones", { name: domain, type: "full", account: { id: accountId } });
  const zone = data.result;
  ok(`Zone created: ${zone.name} (ID: ${zone.id})`);
  ok(`Status: ${zone.status}`);
  log(`${C.dim}Assigned nameservers:${C.reset}`);
  for (const ns of zone.name_servers) {
    log(`  ${C.cyan}${ns}${C.reset}`);
  }
  return zone;
}

async function updateNamesiloNameservers(domain, nameservers) {
  heading(`Updating NameSilo nameservers for: ${domain}`);
  const params = { domain };
  nameservers.forEach((ns, i) => { params[`ns${i + 1}`] = ns; });
  await nsReq("changeNameServers", params);
  ok(`Nameservers updated to:`);
  for (const ns of nameservers) {
    log(`  ${C.cyan}${ns}${C.reset}`);
  }
}

const domain = process.argv[2];
if (!domain) {
  log(`\n${C.bold}Usage:${C.reset} node cloudflare-namesilo-setup.mjs <domain>`);
  log(`\n${C.bold}Example:${C.reset} node cloudflare-namesilo-setup.mjs seedance2video.me`);
  log(`\n${C.bold}Environment:${C.reset}`);
  log(`  CLOUDFLARE_API_KEY         Cloudflare Global API Key`);
  log(`  CLOUDFLARE_EMAIL           Cloudflare account email`);
  log(`  NAMESILO_API_KEY           NameSilo API key\n`);
  process.exit(1);
}

try {
  const zone = await addCloudflareZone(domain);
  await updateNamesiloNameservers(domain, zone.name_servers);

  heading("Done");
  ok(`Zone ID: ${zone.id}`);
  ok(`Nameservers updated at NameSilo`);
  log(`${C.dim}DNS propagation may take up to 24-48 hours.${C.reset}`);
  log(`${C.dim}After propagation, run the Postmark DNS setup:${C.reset}`);
  log(`  node .claude/skills/postmark-setup/scripts/postmark-setup.mjs setup-dns --domain "${domain}" --domain-id <ID>`);
} catch (e) {
  fail(e.message);
  process.exit(1);
}
