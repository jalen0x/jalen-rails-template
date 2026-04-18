#!/usr/bin/env node

import { parseArgs } from "node:util";
import { execSync } from "node:child_process";
import { writeFileSync, unlinkSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const STRIPE_BASE = "https://api.stripe.com/v1";
const ALLOWED_ENVS = ["production", "staging", "development"];

const WEBHOOK_EVENTS = [
  "customer.subscription.created",
  "customer.subscription.updated",
  "customer.subscription.deleted",
  "subscription_schedule.released",
  "subscription_schedule.canceled",
  "subscription_schedule.aborted",
  "charge.succeeded",
  "charge.refunded",
  "checkout.session.completed",
  "checkout.session.async_payment_succeeded",
  "payment_intent.succeeded",
  "invoice.paid",
];

const scriptDir = dirname(fileURLToPath(import.meta.url));
const projectDir = resolve(scriptDir, "../../../..");

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

async function stripeReq(method, path, secretKey, params) {
  const headers = {
    Authorization: `Bearer ${secretKey}`,
    "Content-Type": "application/x-www-form-urlencoded",
  };

  let body;
  if (params) {
    const urlParams = new URLSearchParams();
    for (const [key, value] of Object.entries(params)) {
      if (Array.isArray(value)) {
        value.forEach((v) => urlParams.append(`${key}[]`, v));
      } else {
        urlParams.append(key, value);
      }
    }
    body = urlParams.toString();
  }

  const res = await fetch(`${STRIPE_BASE}${path}`, { method, headers, body });
  const data = await res.json();

  if (data.error) {
    fail(`Stripe ${method} ${path}: ${data.error.message}`);
    process.exit(1);
  }
  return data;
}

function saveToCredentials(env, updates) {
  if (!ALLOWED_ENVS.includes(env)) {
    fail(`--env must be one of: ${ALLOWED_ENVS.join(" / ")}`);
    process.exit(1);
  }

  const tmpScript = resolve(projectDir, "tmp", "update-credentials.rb");
  writeFileSync(tmpScript, [
    'require "yaml"',
    'require "json"',
    "path = ARGV[0]",
    "yaml = YAML.safe_load(File.read(path)) || {}",
    'updates = JSON.parse(ENV.fetch("CRED_UPDATES"))',
    "def deep_merge(h1, h2)",
    "  h1.merge(h2) { |_k, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? deep_merge(v1, v2) : v2 }",
    "end",
    "File.write(path, YAML.dump(deep_merge(yaml, updates)))",
  ].join("\n") + "\n");

  const envFlag = env === "development" ? "" : `-e ${env}`;

  heading(`Saving to Rails credentials (${env})`);
  try {
    execSync(`EDITOR="ruby '${tmpScript}'" bin/rails credentials:edit ${envFlag}`, {
      cwd: projectDir,
      stdio: "inherit",
      env: { ...process.env, CRED_UPDATES: JSON.stringify(updates) },
    });
    ok("Saved to credentials");
  } finally {
    try { unlinkSync(tmpScript); } catch {}
  }
}

function mask(s) {
  if (!s || s.length < 12) return s;
  return s.slice(0, 8) + "..." + s.slice(-4);
}

async function createWebhook(secretKey, domain) {
  heading(`Creating Stripe webhook endpoint`);
  const url = `https://${domain}/webhooks/stripe`;
  log(`  URL: ${url}`);
  log(`  Events: ${WEBHOOK_EVENTS.length}`);

  const data = await stripeReq("POST", "/webhook_endpoints", secretKey, {
    url,
    enabled_events: WEBHOOK_EVENTS,
  });

  ok(`Webhook created: ${data.id}`);
  ok(`Signing secret: ${mask(data.secret)}`);
  return data;
}

async function cmdSetup(args) {
  const { values } = parseArgs({
    args,
    options: {
      "public-key": { type: "string" },
      "secret-key": { type: "string" },
      domain: { type: "string" },
      env: { type: "string" },
    },
    strict: true,
  });

  if (!values["public-key"] || !values["secret-key"] || !values.env) {
    fail("Usage: setup --public-key <pk_...> --secret-key <sk_...> --env <environment> [--domain <domain>]");
    process.exit(1);
  }

  const env = values.env;
  const publicKey = values["public-key"];
  const secretKey = values["secret-key"];
  const isDev = env === "development";

  if (!isDev && !values.domain) {
    fail("--domain is required for staging/production (e.g., --domain example.com)");
    process.exit(1);
  }

  const credentialUpdates = {
    stripe: {
      public_key: publicKey,
      private_key: secretKey,
    },
  };

  if (!isDev) {
    const webhook = await createWebhook(secretKey, values.domain);
    credentialUpdates.stripe.signing_secret = webhook.secret;
  } else {
    heading("Development mode");
    log("  Skipping webhook creation (use 'stripe listen' via Procfile.dev)");
  }

  saveToCredentials(env, credentialUpdates);

  heading("Summary");
  ok(`Environment: ${env}`);
  ok(`Public key: ${mask(publicKey)}`);
  ok(`Secret key: ${mask(secretKey)}`);
  if (credentialUpdates.stripe.signing_secret) {
    ok(`Signing secret: ${mask(credentialUpdates.stripe.signing_secret)}`);
  }
  if (!isDev) {
    ok(`Webhook: https://${values.domain}/webhooks/stripe`);
  }
}

async function cmdCreateWebhook(args) {
  const { values } = parseArgs({
    args,
    options: {
      "secret-key": { type: "string" },
      domain: { type: "string" },
    },
    strict: true,
  });

  if (!values["secret-key"] || !values.domain) {
    fail("Usage: create-webhook --secret-key <sk_...> --domain <domain>");
    process.exit(1);
  }

  await createWebhook(values["secret-key"], values.domain);
}

async function cmdSaveCredentials(args) {
  const { values } = parseArgs({
    args,
    options: {
      "public-key": { type: "string" },
      "secret-key": { type: "string" },
      "signing-secret": { type: "string" },
      env: { type: "string" },
    },
    strict: true,
  });

  if (!values["public-key"] || !values["secret-key"] || !values.env) {
    fail("Usage: save-credentials --public-key <pk_...> --secret-key <sk_...> [--signing-secret <whsec_...>] --env <environment>");
    process.exit(1);
  }

  const updates = {
    stripe: {
      public_key: values["public-key"],
      private_key: values["secret-key"],
    },
  };

  if (values["signing-secret"]) {
    updates.stripe.signing_secret = values["signing-secret"];
  }

  saveToCredentials(values.env, updates);
}

function showHelp() {
  log(`
${C.bold}stripe-setup${C.reset} — Configure Stripe webhook and credentials for Jumpstart Pro Rails

${C.bold}Usage:${C.reset}
  node stripe-setup.mjs <command> [options]

${C.bold}Commands:${C.reset}
  setup              Full flow: create webhook (non-dev) + save credentials
                       --public-key <pk_...>  --secret-key <sk_...>  --env <environment>
                       --domain <domain>  (required for staging/production)

  create-webhook     Create Stripe webhook endpoint only
                       --secret-key <sk_...>  --domain <domain>

  save-credentials   Save Stripe keys to Rails credentials only
                       --public-key <pk_...>  --secret-key <sk_...>  --env <environment>
                       [--signing-secret <whsec_...>]

${C.bold}Environments:${C.reset}
  development   Sandbox keys, no webhook (use 'stripe listen')
  staging       Sandbox keys, webhook via API
  production    Live keys, webhook via API

${C.bold}Webhook Events (${WEBHOOK_EVENTS.length}):${C.reset}
${WEBHOOK_EVENTS.map((e) => `  - ${e}`).join("\n")}
`);
}

const [command, ...rest] = process.argv.slice(2);

const commands = {
  setup: cmdSetup,
  "create-webhook": cmdCreateWebhook,
  "save-credentials": cmdSaveCredentials,
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
