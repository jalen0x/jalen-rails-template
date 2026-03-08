# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Rails 8 starter template for building web applications. It provides modern Rails patterns with Hotwire, Tailwind CSS, and Flowbite UI components.

## Development Commands

```bash
# Initial setup
bin/setup                    # Install dependencies and setup database

# Development server
bin/dev                      # Start development server with Overmind (includes Rails server, asset watching)
bin/rails server            # Standard Rails server only

# Database
bin/rails db:prepare         # Setup database (creates, migrates, seeds)
bin/rails db:migrate         # Run migrations
bin/rails db:seed           # Seed database

# Testing
bin/rails test              # Run test suite (Minitest)
bin/rails test:system       # Run system tests (Capybara + Selenium)

# Code quality
bin/rubocop                 # Run RuboCop linter (configured in .rubocop.yml)
bin/rubocop -a              # Auto-fix RuboCop issues

# Background jobs
bin/jobs                    # Start SolidQueue worker
```

## Technology Stack

- **Rails 8** with Hotwire (Turbo + Stimulus)
- **PostgreSQL** (primary), **SolidQueue** (jobs), **SolidCache** (cache), **SolidCable** (websockets)
- **Import Maps** for JavaScript (no Node.js dependency for Rails JS)
- **TailwindCSS v4** via tailwindcss-rails gem
- **Flowbite 4** for UI components
- **Minitest** for testing with parallel execution
- **Kamal** for deployment

## Testing

- **Minitest** with fixtures in `test/fixtures/`
- **System tests** use Capybara with Selenium WebDriver
- **Test parallelization** enabled via `parallelize(workers: :number_of_processors)`
- **Test database** reset between runs

## UI Color Classes (Flowbite 4 Semantic)

Use Flowbite 4 semantic color classes. Never use hardcoded Tailwind colors (`gray-*`, `blue-*`, `primary-*`) or `dark:` color overrides — semantic variables handle dark mode automatically.

Full variable reference: `node_modules/flowbite/src/themes/default.css`

```erb
<%# Links %>
class="font-medium text-fg-brand hover:underline"

<%# Primary buttons %>
class="text-white bg-brand box-border border border-transparent hover:bg-brand-strong focus:ring-4 focus:ring-brand-medium shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Secondary buttons %>
class="text-body bg-neutral-secondary-medium box-border border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-4 focus:ring-neutral-tertiary shadow-xs font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Danger buttons (outline) %>
class="text-danger bg-neutral-primary border border-danger hover:bg-danger hover:text-white focus:ring-4 focus:ring-neutral-tertiary font-medium leading-5 rounded-base text-sm px-4 py-2.5 focus:outline-none"

<%# Form inputs %>
class="bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full px-3 py-2.5 shadow-xs placeholder:text-body"

<%# Cards/containers %>
class="bg-neutral-primary-soft border border-default rounded-base shadow-xs"

<%# File input (default) %>
class="cursor-pointer bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full shadow-xs placeholder:text-body"

<%# Checkbox (label right of checkbox) %>
<div class="flex items-center">
  <input type="checkbox" class="w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft">
  <label class="select-none ms-2 text-sm font-medium text-heading">Label</label>
</div>
```

**Key rules:**
- `text-white` on brand/danger backgrounds: keep as-is
- `after:bg-white` in toggle switches: keep (slider stays white in both modes)

## Solid Queue Background Job Rules

**Never use `discard_on` to discard jobs!**

Reason: Never discard jobs under any circumstances - retry, debugging, and recovery become very difficult otherwise. Deleting a dead job is just one click.

- ❌ Don't use `discard_on` to silently discard failed jobs
- ❌ Don't rescue exceptions without re-raising
- ✅ Let jobs fail into failed jobs for easy debugging and retry
- ✅ Preserve complete error information and context after job failure
- ⚠️ Rails 8.1+: Use `wait: :polynomially_longer` instead of `:exponentially_longer` (renamed)
