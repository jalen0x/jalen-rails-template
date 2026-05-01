#!/usr/bin/env node

import { parseArgs } from "node:util";

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

function printEnvValues(env, values) {
  if (!ALLOWED_ENVS.includes(env)) {
    fail(`--env must be one of: ${ALLOWED_ENVS.join(" / ")}`);
    process.exit(1);
  }

  heading(`Add these ${env} ENV values to your secret manager / Kamal secrets`);
  for (const [key, value] of Object.entries(values)) {
    log(`${key}=${value}`);
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

  const envValues = {
    STRIPE_PUBLIC_KEY: publicKey,
    STRIPE_SECRET_KEY: secretKey,
  };

  if (!isDev) {
    const webhook = await createWebhook(secretKey, values.domain);
    envValues.STRIPE_SIGNING_SECRET = webhook.secret;
  } else {
    heading("Development mode");
    log("  Skipping webhook creation (use 'stripe listen' via Procfile.dev)");
  }

  printEnvValues(env, envValues);

  heading("Summary");
  ok(`Environment: ${env}`);
  ok(`Public key: ${mask(publicKey)}`);
  ok(`Secret key: ${mask(secretKey)}`);
  if (envValues.STRIPE_SIGNING_SECRET) {
    ok(`Signing secret: ${mask(envValues.STRIPE_SIGNING_SECRET)}`);
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

async function cmdPrintEnv(args) {
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
    fail("Usage: print-env --public-key <pk_...> --secret-key <sk_...> [--signing-secret <whsec_...>] --env <environment>");
    process.exit(1);
  }

  const envValues = {
    STRIPE_PUBLIC_KEY: values["public-key"],
    STRIPE_SECRET_KEY: values["secret-key"],
  };

  if (values["signing-secret"]) {
    envValues.STRIPE_SIGNING_SECRET = values["signing-secret"];
  }

  printEnvValues(values.env, envValues);
}

function showHelp() {
  log(`
${C.bold}stripe-setup${C.reset} — Configure Stripe webhook and ENV values for Jumpstart Pro Rails

${C.bold}Usage:${C.reset}
  node stripe-setup.mjs <command> [options]

${C.bold}Commands:${C.reset}
  setup              Full flow: create webhook (non-dev) + print ENV values
                       --public-key <pk_...>  --secret-key <sk_...>  --env <environment>
                       --domain <domain>  (required for staging/production)

  create-webhook     Create Stripe webhook endpoint only
                       --secret-key <sk_...>  --domain <domain>

  print-env          Print Stripe ENV values only
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
  "print-env": cmdPrintEnv,
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
