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
- **Configure database accessory?** (y/N) - choose `y` if deploying database with Kamal
  - If yes: Enter database accessory host IP
  - If no: Optionally enter external database host IP

This will automatically configure:
- `config/database.yml` - Database names and credentials
- `config/deploy.yml` - Service name, image name, servers, domain, and accessories

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

### First Time Setup

1. Configure your secrets in `.kamal/secrets`:

```bash
# Create .kamal/secrets file with your credentials
KAMAL_REGISTRY_PASSWORD=your_github_token
RAILS_MASTER_KEY=your_master_key
```

2. Deploy your application:

```bash
bin/kamal setup    # First time only - sets up Docker and accessories
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
