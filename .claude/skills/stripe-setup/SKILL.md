---
name: stripe-setup
description: Use when configuring Stripe webhooks, ENV secrets, or product/price setup.
---

# Stripe Setup for Jumpstart Pro Rails

Configure Stripe (Pay gem) with webhook endpoint creation and ENV secret setup.

## Script

`scripts/stripe-setup.mjs` (Node 18+, zero dependencies)

```bash
# Full setup: create webhook + print ENV values
node scripts/stripe-setup.mjs setup \
  --public-key pk_live_xxx --secret-key sk_live_xxx \
  --domain example.com --env production

# Development: print Sandbox ENV values only (webhook handled by stripe listen)
node scripts/stripe-setup.mjs setup \
  --public-key pk_test_xxx --secret-key sk_test_xxx \
  --env development

# Individual commands
node scripts/stripe-setup.mjs create-webhook --secret-key sk_xxx --domain example.com
node scripts/stripe-setup.mjs print-env --public-key pk_xxx --secret-key sk_xxx --env production
```

The `setup` command prints ENV values for your secret manager / Kamal secrets. For staging/production, it also creates a Stripe webhook endpoint with 11 Pay gem events.

## Workflow

### 1. Ask Target Environment

Ask user: development, staging, or production.

| | Development | Staging | Production |
|---|---|---|---|
| Stripe | Sandbox (`pk_test_`/`sk_test_`) | Sandbox | Live (`pk_live_`/`sk_live_`) |
| Secrets | local ENV / secret manager | Kamal secrets | Kamal secrets |
| Webhook | `stripe listen` (Procfile.dev) | API → `https://{domain}/webhooks/stripe` | API → `https://{domain}/webhooks/stripe` |

### 2. Create Stripe Products and Prices

Read `db/seeds.rb` to find Plan and CreditPackage definitions. Guide the user to create matching products in Stripe Dashboard (Sandbox or Live mode).

After creation, user provides prices CSV or Price ID list. Update `db/seeds.rb` with new `stripe_id` values for each Plan and CreditPackage.

### 3. Run Script

Collect API keys from user, then run the setup script:
- **development**: `setup --public-key ... --secret-key ... --env development`
- **staging/production**: `setup --public-key ... --secret-key ... --domain ... --env <env>`

### 4. Post-Setup (Production Only)

Remind user to configure in Stripe Dashboard → Settings → Public details:
- Terms of Service URL (e.g., `https://example.com/terms`)
- Privacy Policy URL (e.g., `https://example.com/privacy`)

Required to avoid `Stripe::InvalidRequestError` when collecting terms consent during checkout.

### 5. Deploy and Verify

- **development**: `bin/dev` (stripe listen auto-starts via Procfile.dev)
- **staging/production**: Deploy, then run `db:seed` if needed to sync Plan records. Verify webhook status in Stripe Dashboard.
