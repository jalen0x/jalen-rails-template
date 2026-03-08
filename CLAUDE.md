# CLAUDE.md

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
- ⚠️ Rails 8.1+: Use `wait: :polynomially_longer` instead of `:exponentially_longer` (renamed)
