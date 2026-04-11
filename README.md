# 🚀 Jalen Rails Template

Welcome! This is a Rails application template with pre-configured deployment setup using Kamal.

## Requirements

You'll need the following installed to run the template successfully:

* Ruby 3.2+
* PostgreSQL 12+
* Node.js 18+ and Yarn
* Libvips or Imagemagick

## Create Your Repository

Create a [new Git](https://github.com/new) repository for your project. Then you can clone this template and push it to your new repository.

```bash
git clone git@github.com:jalen0x/jalen-rails-template.git myapp
cd myapp
git remote rename origin upstream
git remote add origin git@github.com:your-username/your-repo.git # Replace with your new Git repository url
git push -u origin main
```

## Initial Setup

First, configure your project name:

```bash
bin/rails setup:project
```

You will be prompted to enter:
- **Project name** (e.g., `musicforge.ai`) - will be converted to Rails-style database naming
- **Web server IP** - leave empty to keep current settings

This will automatically configure:
- `config/database.yml` - Database names and credentials
- `config/deploy.yml` - Service name, image name, servers, domain, and the
  `db` Kamal accessory (PostgreSQL 18 running on the same host, reachable by
  the app container through the `kamal` Docker network as `<prefix>-db`)

Next, create your Rails credentials file:

```bash
# If you're joining an existing project, request master key from team
# Save the key to config/master.key

# To create new credentials:
EDITOR=vim bin/rails credentials:edit
# This will create config/credentials.yml.enc
# Save and exit the editor to complete the creation
```

Then run `bin/setup` to install Ruby and JavaScript dependencies and setup your database:

```bash
bin/setup
```

## Running the Application

To run your application, use the `bin/dev` command:

```bash
bin/dev
```

This starts up the processes defined in `Procfile.dev`:
- Rails server
- CSS bundling (Tailwind)
- JS bundling

You can add background workers or other services to `Procfile.dev` as needed.

## Deployment with Kamal

This template is pre-configured for deployment with [Kamal](https://kamal-deploy.org/).

### Secrets pattern

The template follows a "minimal 1Password" pattern:

- **1Password** holds only `RAILS_MASTER_KEY` — everything else lives inside
  Rails production credentials and is decrypted at deploy time by the
  commands in `.kamal/secrets`.
- **`config/credentials/production.yml.enc`** is the single source of truth
  for `kamal.registry_password`, `database.password`, `ssl.certificate`,
  `ssl.private_key`, and any app-level secrets (`secret_key_base`,
  `mcp.token`, `cloudflare.*`, …). Rails does **not** merge shared and
  environment-specific credentials — when a production-specific file exists,
  it is used alone, so production credentials must contain every key
  Rails needs in production, including `secret_key_base`.
- Align `config/credentials/production.key` with `config/master.key` so the
  container can decrypt both shared and production credentials using the
  same `RAILS_MASTER_KEY` env var:

  ```bash
  cp config/master.key config/credentials/production.key
  ```

### First-time setup

1. Point the `SECRETS=$(kamal secrets fetch …)` line in `.kamal/secrets` at
   the 1Password vault/item holding your `RAILS_MASTER_KEY`.
2. Create production credentials and populate them:

   ```bash
   EDITOR=vim bin/rails credentials:edit -e production
   ```

3. Deploy:

   ```bash
   bin/kamal setup    # First time only — installs Docker + boots the `db` accessory
   bin/kamal deploy   # Deploy the application
   ```

### Subsequent Deployments

```bash
bin/kamal deploy
```

### Useful Kamal Commands

```bash
bin/kamal app logs -f          # Tail application logs
bin/kamal app exec -i "bash"   # SSH into the app container
bin/kamal console              # Rails console (alias)
bin/kamal dbc                  # Rails dbconsole (alias)
```

## Project Structure

```
.
├── app/                    # Application code
├── config/
│   ├── database.yml        # Database configuration (generated from template)
│   └── deploy.yml          # Kamal deployment config (generated from template)
├── lib/
│   ├── tasks/
│   │   └── setup.rake      # Project setup task
│   └── templates/
│       ├── database.yml.tt # Database config template
│       └── deploy.yml.tt   # Deploy config template
└── ...
```

## Merging Updates

To merge changes from the template, you will merge from the `upstream` remote:

```bash
git fetch upstream
git merge upstream/main
```

## Contributing

If you have an improvement you'd like to share, create a fork of the repository and send us a pull request.

## License

This template is available as open source under the terms of the MIT License.
