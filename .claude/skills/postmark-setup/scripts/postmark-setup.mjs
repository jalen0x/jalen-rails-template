#!/usr/bin/env node

import { parseArgs } from "node:util";

const POSTMARK_BASE = "https://api.postmarkapp.com";
const CF_BASE = "https://api.cloudflare.com/client/v4";
const ALLOWED_ENVS = ["production", "staging", "development"];

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

async function postmarkReq(method, path, body) {
  const token = requireEnv("POSTMARK_ACCOUNT_TOKEN");
  const res = await fetch(`${POSTMARK_BASE}${path}`, {
    method,
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-Postmark-Account-Token": token,
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const data = await res.json();
  if (!res.ok) {
    fail(`Postmark ${method} ${path}: ${res.status} - ${data.Message || JSON.stringify(data)}`);
    process.exit(1);
  }
  return data;
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
    const errors = (data.errors || []).map((e) => e.message).join(", ");
    fail(`Cloudflare ${method} ${path}: ${errors}`);
    process.exit(1);
  }
  return data;
}

function printEnvValues(env, values) {
  if (!ALLOWED_ENVS.includes(env)) {
    fail(`--env 必须是 ${ALLOWED_ENVS.join(" / ")}`);
    process.exit(1);
  }

  heading(`Add these ${env} ENV values to your secret manager / Kamal secrets`);
  for (const [key, value] of Object.entries(values)) {
    log(`${key}=${value}`);
  }
}

async function createServer(name) {
  heading(`Creating Postmark Server: ${name}`);
  const data = await postmarkReq("POST", "/servers", {
    Name: name,
    Color: "blue",
    DeliveryType: "Live",
  });
  ok(`Server created: ID=${data.ID}`);
  ok(`postmark_api_token: ${data.ApiTokens[0]}`);
  return data;
}

async function addDomain(domain) {
  heading(`Adding domain to Postmark: ${domain}`);
  const data = await postmarkReq("POST", "/domains", {
    Name: domain,
    ReturnPathDomain: `pm-bounces.${domain}`,
  });
  ok(`Domain added: ID=${data.ID}`);
  return data;
}

async function getDomainDetails(domainId) {
  return await postmarkReq("GET", `/domains/${domainId}`);
}

async function findCfZone(domain) {
  const parts = domain.split(".");
  const rootDomain = parts.slice(-2).join(".");
  heading(`Finding Cloudflare zone for: ${rootDomain}`);
  const data = await cfReq("GET", `/zones?name=${rootDomain}`);
  if (!data.result || data.result.length === 0) {
    fail(`Zone not found for domain: ${rootDomain}`);
    process.exit(1);
  }
  const zone = data.result[0];
  ok(`Zone found: ${zone.name} (${zone.id})`);
  return zone.id;
}

async function dnsRecordExists(zoneId, type, name) {
  const data = await cfReq("GET", `/zones/${zoneId}/dns_records?type=${type}&name=${name}`);
  return data.result && data.result.length > 0;
}

async function createDnsRecord(zoneId, record) {
  const exists = await dnsRecordExists(zoneId, record.type, record.name);
  if (exists) {
    warn(`DNS record already exists: ${record.type} ${record.name} — skipped`);
    return;
  }
  await cfReq("POST", `/zones/${zoneId}/dns_records`, {
    type: record.type,
    name: record.name,
    content: record.content,
    ttl: 1,
    proxied: false,
  });
  ok(`DNS record created: ${record.type} ${record.name}`);
}

async function setupDns(domain, domainId) {
  heading("Setting up DNS records via Cloudflare");
  const details = await getDomainDetails(domainId);
  const zoneId = await findCfZone(domain);

  const records = [];

  if (details.DKIMPendingHost && details.DKIMPendingTextValue) {
    records.push({ type: "TXT", name: details.DKIMPendingHost, content: details.DKIMPendingTextValue });
  } else if (details.DKIMHost && details.DKIMTextValue) {
    records.push({ type: "TXT", name: details.DKIMHost, content: details.DKIMTextValue });
  }

  if (details.ReturnPathDomainCNAMEValue) {
    records.push({
      type: "CNAME",
      name: details.ReturnPathDomain || `pm-bounces.${domain}`,
      content: details.ReturnPathDomainCNAMEValue,
    });
  }

  if (records.length === 0) {
    warn("No DNS records to create from Postmark domain details");
    return;
  }

  for (const r of records) {
    await createDnsRecord(zoneId, r);
  }
}

async function cmdSetup(args) {
  const { values } = parseArgs({
    args,
    options: {
      server: { type: "string" },
      domain: { type: "string" },
      env: { type: "string" },
    },
    strict: true,
  });
  if (!values.server || !values.domain || !values.env) {
    fail("Usage: setup --server <name> --domain <domain> --env <environment>");
    process.exit(1);
  }

  const server = await createServer(values.server);
  const domainData = await addDomain(values.domain);
  await setupDns(values.domain, domainData.ID);

  printEnvValues(values.env, { POSTMARK_API_TOKEN: server.ApiTokens[0] });

  heading("Summary");
  ok(`Server: ${values.server} (ID: ${server.ID})`);
  ok(`postmark_api_token: ${server.ApiTokens[0]}`);
  ok(`Domain: ${values.domain} (ID: ${domainData.ID})`);
  log(`${C.dim}Run 'node postmark-setup.mjs verify-dns --domain-id ${domainData.ID}' after DNS propagation to verify.${C.reset}`);
}

async function cmdCreateServer(args) {
  const { values } = parseArgs({ args, options: { name: { type: "string" }, env: { type: "string" } }, strict: true });
  if (!values.name || !values.env) { fail("Usage: create-server --name <name> --env <environment>"); process.exit(1); }
  const server = await createServer(values.name);
  printEnvValues(values.env, { POSTMARK_API_TOKEN: server.ApiTokens[0] });
}

async function cmdAddDomain(args) {
  const { values } = parseArgs({ args, options: { domain: { type: "string" } }, strict: true });
  if (!values.domain) { fail("Usage: add-domain --domain <domain>"); process.exit(1); }
  const data = await addDomain(values.domain);
  log(`Domain ID: ${data.ID}`);
}

async function cmdSetupDns(args) {
  const { values } = parseArgs({
    args,
    options: {
      domain: { type: "string" },
      "domain-id": { type: "string" },
    },
    strict: true,
  });
  if (!values.domain || !values["domain-id"]) {
    fail("Usage: setup-dns --domain <domain> --domain-id <id>");
    process.exit(1);
  }
  const domainId = Number(values["domain-id"]);
  if (!Number.isInteger(domainId) || domainId <= 0) {
    fail("--domain-id must be a positive integer");
    process.exit(1);
  }
  await setupDns(values.domain, domainId);
}

async function cmdVerifyDns(args) {
  const { values } = parseArgs({ args, options: { "domain-id": { type: "string" } }, strict: true });
  if (!values["domain-id"]) { fail("Usage: verify-dns --domain-id <id>"); process.exit(1); }
  const domainId = values["domain-id"];
  heading("Verifying DNS for Postmark domain");
  await postmarkReq("PUT", `/domains/${domainId}/verifyDkim`);
  await postmarkReq("PUT", `/domains/${domainId}/verifyReturnPath`);
  const details = await postmarkReq("GET", `/domains/${domainId}`);
  if (details.DKIMVerified) ok("DKIM verified"); else warn("DKIM not yet verified");
  if (details.ReturnPathDomainVerified) ok("Return-Path verified"); else warn("Return-Path not yet verified");
}

function showHelp() {
  log(`
${C.bold}postmark-setup${C.reset} — Create Postmark server & configure domain DNS via Cloudflare

${C.bold}Usage:${C.reset}
  node postmark-setup.mjs <command> [options]

${C.bold}Commands:${C.reset}
  setup          Full flow: create server + add domain + configure DNS
                   --server <name>  --domain <domain>  --env <environment>
  create-server  Create a Postmark server
                   --name <name>  --env <environment>
  add-domain     Add a domain to Postmark
                   --domain <domain>
  setup-dns      Add Postmark DNS records to Cloudflare
                   --domain <domain>  --domain-id <id>
  verify-dns     Verify DKIM and Return-Path after DNS propagation
                   --domain-id <id>

${C.bold}Environment:${C.reset}
  POSTMARK_ACCOUNT_TOKEN   Postmark Account API token
  CLOUDFLARE_API_KEY           Cloudflare Global API Key
  CLOUDFLARE_EMAIL             Cloudflare account email
`);
}

const [command, ...rest] = process.argv.slice(2);

const commands = {
  setup: cmdSetup,
  "create-server": cmdCreateServer,
  "add-domain": cmdAddDomain,
  "setup-dns": cmdSetupDns,
  "verify-dns": cmdVerifyDns,
};

if (!command || command === "--help" || command === "-h") {
  showHelp();
} else if (commands[command]) {
  commands[command](rest).catch((e) => { fail(e.message); process.exit(1); });
} else {
  fail(`Unknown command: ${command}`);
  showHelp();
  process.exit(1);
}
