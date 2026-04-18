# Design Templates

Curated `DESIGN.md` files — drop one into a new project as visual guidance for AI coding agents (Claude, Cursor, Codex).

## Source

Copied from [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) (MIT license), pinned to commit [`80bbbc23ea94`](https://github.com/VoltAgent/awesome-design-md/tree/80bbbc23ea94) — the last revision that still shipped the full Markdown content in-repo (HEAD has since migrated to `getdesign.md`).

Original extraction methodology: each file is auto-extracted from the public website, so colors/fonts/spacing are approximations, not official tokens.

## Available Templates

| File | Style | Best for |
|------|-------|----------|
| [`linear-design.md`](./linear-design.md) | Dark-mode-native, Inter, indigo accent | Modern SaaS dashboards, engineer-facing tools |
| [`stripe-design.md`](./stripe-design.md) | sohne-var, navy + violet, layered shadows | Billing/payments pages, fintech UI |
| [`vercel-design.md`](./vercel-design.md) | Monochrome black/white, geometric | Dev tools, docs sites |
| [`notion-design.md`](./notion-design.md) | Soft neutral, playful serif accents | Content-heavy, CMS-style apps |
| [`cal-design.md`](./cal-design.md) | Clean SaaS, rounded components | Scheduling, light SaaS |
| [`resend-design.md`](./resend-design.md) | Modern flat, email-product aesthetic | Email, notifications, transactional UI |
| [`supabase-design.md`](./supabase-design.md) | Developer green, dark terminal vibe | Backend services, data tooling |
| [`claude-design.md`](./claude-design.md) | Warm parchment, serif headlines, terracotta | AI products, conversational UI |

## How to Use

1. Pick one template that matches the product you're building.
2. Copy it to your project root as `DESIGN.md` (or keep it wherever, just reference the path).
3. In your AI agent prompt, say: _"Follow `DESIGN.md` when generating any UI in this project — use its color tokens, typography, spacing, and component patterns."_
4. The agent will produce UI that matches the template's visual language.

## Interaction with Jumpstart Pro's default styling

Jumpstart Pro ships with Tailwind v4 + Flowbite semantic tokens (`bg-brand`, `text-heading`, `border-default`, …) and Inter font in `app/assets/tailwind/application.css`. A template's palette and typography will override or clash with those tokens if applied without adjustment.

Any page — including admin, dashboard, auth, billing — can adopt a template. The question is just scope vs. effort:

| Scope | Effort |
|-------|--------|
| One-off marketing/landing page written from scratch | Low — drop template in, style new components against it |
| Mixed pages reusing some Flowbite components | Medium — override Flowbite's semantic variables on affected pages, or write Tailwind arbitrary values matching the template |
| Admin/dashboard re-skin | Medium-high — remap `--color-brand`, `--color-fg-*`, `--color-bg-*` etc. in `application.css` so Flowbite components inherit the template palette |
| Whole-app visual overhaul | High — rewrite `application.css` variables + Inter → template font + audit all views for hardcoded colors |

Rule of thumb: the more Flowbite components on a page, the more rewiring is needed. Pick the template first, then plan the re-skin scope accordingly.

## Adding more

The upstream repo has 58 templates at the pinned commit. To add another:

```bash
curl -o docs/design-templates/<name>-design.md \
  https://raw.githubusercontent.com/VoltAgent/awesome-design-md/80bbbc23ea94/design-md/<brand-dir>/DESIGN.md
```

(The `-design.md` suffix is a convention to avoid Claude Code's case-insensitive auto-load of `CLAUDE.md` on macOS.)

Browse available brand directories: <https://github.com/VoltAgent/awesome-design-md/tree/80bbbc23ea94/design-md>
