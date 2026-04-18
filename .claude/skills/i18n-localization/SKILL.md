---
name: i18n-localization
description: Use when adding a new locale or doing SEO-driven i18n keyword research.
---

# SEO-Driven i18n Localization

Add new languages to a Jumpstart Pro Rails app using **keyword-researched localization** — not simple AI translation. The goal: every translated string uses the words local users actually search for, maximizing SEO impact.

## Workflow Overview

```
Phase 1: Keyword Research  →  Find what locals actually search
Phase 2: Localized Translation  →  Write locale files using researched keywords
Phase 3: Rails Integration  →  Wire up config, devise, routes
Phase 4: RTL Layout (if RTL locale)  →  Convert physical CSS to logical properties
Phase 5: Verification  →  Validate YAML, keys, rendering, SEO tags
```

## Phase 1: Keyword Research

**Critical**: Do NOT skip this phase. AI-translated keywords ≠ keywords locals search for.

For the detailed methodology, read [references/keyword-research.md](references/keyword-research.md).

**Quick summary** — for each target language, perform multiple web searches to:
1. Find how competing products express core concepts in the target language
2. Discover local slang/abbreviations (e.g., Korean "브금" for BGM)
3. Identify high-volume search terms vs. literal translations
4. Build a keyword mapping table: English term → researched local term

**Output**: A keyword mapping table covering all SEO-critical terms (meta titles, descriptions, hero text, FAQ, structured data).

## Phase 2: Localized Translation

Split content into two tiers with different strategies:

### Tier 1: SEO Pages (keyword-driven, NOT direct translation)

These sections directly affect search rankings — use researched keywords:
- `public.index` — Homepage (meta tags, hero, features, FAQ, testimonials)
- `public.ai_background_music_generator` — Landing page (meta tags, keywords, structured data JSON-LD with `inLanguage` set to target locale)
- `pricing.show` — Pricing page (meta tags, plan descriptions)
- `dashboard.show` — Dashboard (meta tags)

Rules:
- Use researched keywords naturally; do not keyword-stuff
- Rewrite structured_data JSON-LD: change `inLanguage`, localize `name`/`headline`/`description`/`about`/breadcrumb names, keep URLs with locale prefix
- meta_keywords: use researched local terms, not translations of English keywords

### Tier 2: UI Text (natural translation, no SEO optimization needed)

Translate naturally and idiomatically. Refer to how competing products in the target market express these concepts:
- Common UI (buttons, confirmations, errors)
- Account management, billing, subscriptions
- Editor interface, song management
- Email templates, notifications
- Form validations (activemodel/activerecord errors)
- Helpers, layouts

### Translation Rules

- Preserve all `%{variable}` placeholders exactly
- Preserve all HTML tags in `_html` keys
- Keep YAML indentation consistent (2 spaces)
- For pluralization: Korean/Chinese/Japanese use `other` only; add `one` key with same value for Rails compatibility
- Genre/mood/instrument tags in `quick_add_tags` stay in English (universal music terms)

## Phase 3: Rails Integration

### 3a. Update available_locales

```ruby
# config/application.rb
config.i18n.available_locales = [ :en, :"zh-CN", :ko ]  # add new locale
```

### 3b. Update language helper

Add the new locale to `LANGUAGES` hash in `app/helpers/language_helper.rb` with the language's native name:

```ruby
# app/helpers/language_helper.rb
LANGUAGES = {
  de: "Deutsch",
  en: "English",
  ko: "한국어",
  "zh-CN": "中文"
}
```

This hash powers the locale selector bar dropdown. Always use the language's native name (e.g., "Deutsch" not "German", "한국어" not "Korean").

### 3c. Create locale files

| File | Purpose |
|------|---------|
| `config/locales/{locale}.yml` | Main translations (mirror all keys from en.yml) |
| `config/locales/devise.{locale}.yml` | Devise auth translations (mirror devise.en.yml) |

### 3d. Route translator

If `route_translator` gem is used, locale routes are auto-generated. No separate route translation file needed unless custom route names are required.

## Phase 4: RTL Layout (for RTL locales)

**Skip this phase** for LTR locales (most languages). **Required** for Arabic, Hebrew, Farsi, Urdu.

For the detailed guide, read [references/rtl-layout.md](references/rtl-layout.md).

### 4a. Add RTL helper infrastructure

Add `RTL_LOCALES`, `rtl?`, and `text_dir` to `app/helpers/language_helper.rb` (if not already present):

```ruby
RTL_LOCALES = %i[ar he fa ur].freeze

def rtl?
  RTL_LOCALES.include?(I18n.locale.to_s.split("-").first.to_sym)
end

def text_dir
  rtl? ? "rtl" : "ltr"
end
```

Set `dir` on the `<html>` tag in `app/views/layouts/application.html.erb`:

```erb
<html dir="<%= text_dir %>" lang="<%= I18n.locale %>">
```

### 4b. Convert physical CSS classes to logical properties

Replace all physical direction classes in `app/views/` with logical equivalents (full table with CSS properties in [references/rtl-layout.md](references/rtl-layout.md)):

| Physical (LTR-only) | Logical (LTR+RTL) |
|---------------------|-------------------|
| `ml-*` | `ms-*` |
| `mr-*` | `me-*` |
| `pl-*` | `ps-*` |
| `pr-*` | `pe-*` |
| `left-*` | `start-*` |
| `right-*` | `end-*` |
| `text-left` | `text-start` |
| `text-right` | `text-end` |
| `border-l-*` | `border-s-*` |
| `border-r-*` | `border-e-*` |
| `rounded-l-*` | `rounded-s-*` |
| `rounded-r-*` | `rounded-e-*` |

Responsive variants follow the same pattern: `sm:text-right` → `sm:text-end`, `lg:pr-0` → `lg:pe-0`.

### 4c. Exceptions — keep physical

- **Progress bars**: `left-0` for fill bar positioning
- **Gradients**: `bg-gradient-to-r` is visual, not directional
- **Decorative animations**: absolute-positioned elements
- **Flowbite JS API**: `data-dropdown-placement="right-start"`
- **SVG path coordinates**: `d="..."` values are drawing commands, never change

### 4d. Sidebar RTL

Off-canvas sidebars need explicit RTL handling:

```erb
<aside class="fixed start-0 top-0 -translate-x-full lg:translate-x-0
              rtl:translate-x-full rtl:lg:translate-x-0
              border-e border-default">
```

### 4e. Turbo Drive caveat

Turbo Drive only replaces `<body>` — `<html dir="...">` is NOT updated on Turbo navigation. All locale-switching links **must** have `data-turbo="false"` to force a full page reload. See [references/rtl-layout.md](references/rtl-layout.md) Gotcha #7 for details.

### 4f. Verify zero remaining physical classes

```bash
grep -rn --include="*.erb" -E '\b(ml-|mr-|pl-|pr-)[0-9]' app/views/
grep -rn --include="*.erb" -E '\b(text-left|text-right)\b' app/views/
grep -rn --include="*.erb" -E '\b(border-l|border-r)-' app/views/
```

Review each match — some are legitimate exceptions (see 4c above).

## Phase 5: Verification

Run these checks after creating locale files:

```bash
# 1. YAML syntax
ruby -e "require 'yaml'; YAML.load_file('config/locales/{locale}.yml'); puts 'OK'"
ruby -e "require 'yaml'; YAML.load_file('config/locales/devise.{locale}.yml'); puts 'OK'"

# 2. Key completeness (must show 0 missing)
ruby -e "
require 'yaml'
def flatten_keys(hash, prefix = '')
  hash.each_with_object([]) do |(k, v), keys|
    key = prefix.empty? ? k.to_s : \"#{prefix}.#{k}\"
    v.is_a?(Hash) ? keys.concat(flatten_keys(v, key)) : keys << key
  end
end
en = flatten_keys(YAML.load_file('config/locales/en.yml')['en']).sort
loc = flatten_keys(YAML.load_file('config/locales/{locale}.yml')['{locale}']).sort
missing = en - loc
puts \"EN: #{en.size} | Target: #{loc.size} | Missing: #{missing.size}\"
missing.each { |k| puts \"  - #{k}\" } if missing.any?
"

# 3. Rails loads locale
bin/rails runner "puts I18n.available_locales"
```

Then verify in browser:
- Visit `/{locale}` — page renders in target language
- Check `<title>`, `<meta description>`, `<meta keywords>` contain researched keywords
- Check structured data (JSON-LD) outputs correct `inLanguage` and localized content

## Key Principles

1. **One language at a time** — complete research → translation → verification for each language before starting the next
2. **SEO pages first** — prioritize pages that affect search rankings
3. **Consistency** — build a term glossary before translating; use identical terms throughout
4. **Local idiom > literal translation** — if locals say "요금제" instead of "플랜", use "요금제"
5. **Verify before shipping** — 0 missing keys, valid YAML, correct meta tags
