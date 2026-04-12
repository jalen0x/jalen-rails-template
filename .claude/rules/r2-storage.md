---
paths:
  - "config/storage.yml"
  - "app/models/**/*.rb"
---

# Cloudflare R2 Active Storage

Production uses Cloudflare R2 via the standard S3 service. Development and test stay on local disk.

## Configuration

- `config/storage.yml` has a `cloudflare:` service block using `Rails.application.credentials.dig(:cloudflare, ...)`.
- `config/environments/production.rb` sets `config.active_storage.service = :cloudflare`.
- Credentials shape (see `lib/templates/rails/credentials/credentials.yml.tt`):

```yaml
cloudflare:
  account_id: your_account_id
  r2:
    access_key_id: your_access_key
    secret_access_key: your_secret_key
    bucket_name: your_bucket
```

## Active Storage Usage Rules

- **Upload key should include the product/domain name** in the filename so downloaded files carry brand identity.
- **Don't add URL columns** to migrations — Active Storage provides URL helpers; storing URLs is redundant and goes stale.
- **Don't wrap uploads in a service** — Rails auto-attaches on `save!`. No manual `create_and_upload!`.
- Use `has_one_attached` / `has_many_attached` directly; permit attachment params in the controller and let Rails handle the rest.
- When downloading, use `blob.filename` directly — don't re-add the domain that's already in the key.
- **Purge attached files before soft-deleting**: `image.purge if image.attached?` before `record.discard!`, otherwise the blob is orphaned.
- Index / list pages must use variants (thumbnails) — never render full-size images in collections.
- Video thumbnails require `ffmpeg` installed in the Docker image — add to the Dockerfile before using `video.preview`.

## When Adding New Storage Credentials

Edit `lib/templates/rails/credentials/credentials.yml.tt` so future `bin/rails credentials:edit` runs in fresh environments see the expected shape.
