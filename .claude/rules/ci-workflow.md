---
paths:
  - "bin/setup"
  - "bin/dev"
  - "bin/ci"
  - "bin/update"
  - "bin/db-*"
  - ".github/workflows/**/*.yml"
  - ".github/dependabot.yml"
---

# Sustainable Workflow Scripts

Automation beats documentation. `bin/setup`, `bin/dev`, and `bin/ci` are the living README.

## `bin/setup`

- Must be idempotent: repeated runs leave the app ready to work.
- Should be runnable by a new developer after cloning with minimal context.
- Use Ruby stdlib / shell only before dependencies are installed.
- Print command-originated log lines (`[ bin/setup ] ...`) so failures are easy to trace.
- Support `-h`, `--help`, and `help`.
- In CI, prefer matching local service names. If impossible, generate ignored local env files from `bin/setup` based on `ENV["CI"] == "true"`.

## `bin/dev`

- Starts the local development environment and only the local development environment.
- Keep process orchestration in the script/Procfile, not in README prose.
- If the app needs multiple processes, `bin/dev` owns that setup.

## `bin/ci`

- Runs the checks required before merge/deploy.
- Put fastest, highest-signal feedback first.
- Do not disable tests because the suite is slow. Split checks into parallel scripts (`bin/unit-tests`, `bin/system-tests`, `bin/security-audits`) if needed.
- The CI entrypoint should run `bin/setup`, then `bin/setup` again to verify idempotency, then the remaining `bin/ci` checks. This can live inside `bin/ci` so local and hosted CI use the same path.

## Package Manager Consistency

- The lockfile chooses the JavaScript package manager. `bun.lock` means CI, Docker, `bin/setup`, and `bin/dev` use Bun.
- Do not mix Yarn/npm install steps or caches into a Bun project unless the repo intentionally carries the matching lockfile and scripts.
- Hosted CI should exercise the same commands as local development. If the workflow adds explicit install/build steps for caching or artifacts, they must match the `bin/` scripts.

## Documentation Rule

If a README/runbook says "run these steps," prefer turning those steps into a `bin/` script or Rake task. Humans copy the wrong IDs and skip steps under pressure; automation does not.
