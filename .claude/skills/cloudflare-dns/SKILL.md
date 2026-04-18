---
name: cloudflare-dns
description: Use when adding a domain to Cloudflare or updating nameservers.
---

# Cloudflare DNS

Add a domain to Cloudflare and update NameSilo nameservers in one step.

## Script

`scripts/cloudflare-namesilo-setup.mjs` (Node 18+, zero dependencies)

```bash
node scripts/cloudflare-namesilo-setup.mjs <domain>
```

**Environment Variables:**

```
CLOUDFLARE_API_KEY     - Cloudflare Global API Key
CLOUDFLARE_EMAIL       - Cloudflare account email
NAMESILO_API_KEY       - NameSilo API key
```

## What It Does

1. Create Cloudflare zone for the domain
2. Read assigned nameservers from Cloudflare
3. Update NameSilo nameservers to match

## After Completion

DNS propagation takes 24-48 hours. Once propagated, use the `postmark-setup` skill to configure email DNS records.
