---
paths:
  - "config/**/*.rb"
  - "config/*.yml"
  - "lib/templates/**/*.tt"
  - ".kamal/secrets"
  - ".env*"
  - "bin/setup"
  - "bin/dev"
  - "bin/ci"
---

# Runtime Configuration & Secrets

Use one runtime configuration mechanism so setup, deploys, and AI-assisted changes stay predictable. For this template, runtime config is **ENV-only**.

## ENV-Only Defaults

- Runtime configuration and secrets should be read from `ENV.fetch(...)` or explicit `ENV[...]` comparisons.
- Use Kamal secrets / deployment environment variables to supply production values.
- Do not add or read `Rails.application.credentials`. Credentials are opaque to agents and create extra tooling friction.

```ruby
GithubClient.new(token: ENV.fetch("GITHUB_TOKEN"))
```

## ENV Values Are Strings

Ruby `ENV` only stores strings. Never rely on truthiness for flags:

```ruby
# Bad: "false" is truthy
if ENV["FEATURE_DISABLED"]
  disable_feature
end

# Good
if ENV["FEATURE_DISABLED"] == "true"
  disable_feature
end
```

Use `ENV.fetch("NAME")` for required values so boot fails loudly when config is missing. Use `ENV.fetch("NAME", "default")` only for safe defaults.

## Local Development Files

- Commit non-secret defaults in `.env.development` / `.env.test` only after the project intentionally adds a Rails env-file loader such as `dotenv-rails` in development/test.
- Do not rely on `dotenv` arriving as a transitive dependency of another tool; if Rails should load env files, add and document that dependency directly.
- Ignore `.env`, `.env.local`, and `.env.*.local`; these hold machine-local secrets.
- `bin/setup` may generate `.env.development.local` / `.env.test.local` for CI-specific values when CI cannot match local service names.

## No Rails Credentials

- Do not use `bin/rails credentials:edit` for app configuration.
- Do not commit `config/master.key`, `config/credentials/*.key`, `config/credentials.yml.enc`, `config/credentials/*.yml.enc`, or raw secret values.
- If an existing upstream file suggests credentials, convert the setting to ENV instead of adding a credentials fallback.

## Database Config

`config/database.yml` should read connection details from ENV (`DATABASE_URL`, `DB_HOST`, `POSTGRES_PASSWORD`, etc.). Do not read database passwords from credentials.
