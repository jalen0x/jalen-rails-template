---
name: postmark-setup
description: Use when setting up Postmark email server and DKIM/Return-Path DNS.
---

# Postmark Setup

Create Postmark server, add sender domain, and configure DKIM/Return-Path DNS via Cloudflare.

## Script

`scripts/postmark-setup.mjs` (Node 18+, zero dependencies)

```bash
# Full setup: create server + add domain + configure DNS + save credentials
node scripts/postmark-setup.mjs setup --server "example.me" --domain "example.me" --env production

# Individual steps
node scripts/postmark-setup.mjs create-server --name "example.me" --env production
node scripts/postmark-setup.mjs add-domain --domain "example.me"
node scripts/postmark-setup.mjs setup-dns --domain "example.me" --domain-id 12345
node scripts/postmark-setup.mjs verify-dns --domain-id 12345
```

`setup` and `create-server` commands require `--env` to automatically save `postmark.api_token` to Rails encrypted credentials (deep merge).

**Environment Variables:**

```
POSTMARK_ACCOUNT_TOKEN     - Postmark Account API token
CLOUDFLARE_API_KEY         - Cloudflare Global API Key
CLOUDFLARE_EMAIL           - Cloudflare account email
```

## Workflow

1. `setup` — Full flow: create server, add domain, configure DNS records, save credentials
2. `setup-dns` — Add DKIM/Return-Path DNS if skipped (e.g., NS not propagated yet)
3. `verify-dns` — Verify DKIM and Return-Path after DNS propagation

## Prerequisites

The domain must already have a Cloudflare zone. Use the `cloudflare-dns` skill first if needed.
