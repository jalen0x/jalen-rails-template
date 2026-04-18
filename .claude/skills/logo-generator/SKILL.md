---
name: logo-generator
description: Use when generating SVG logos, favicons, or updating brand assets.
---

# Logo Generator

Generate or update brand assets (SVG logos, favicons, PNG icons) for Jumpstart Pro Rails projects.

## Jumpstart Pro Standard File Locations

| File | Location | Usage |
|------|----------|-------|
| `logo.svg` | `app/assets/images/` (overrides `lib/jumpstart/`) | Navbar: `render_svg "logo"` |
| `mark.svg` | `app/assets/images/` (overrides `lib/jumpstart/`) | Footer: `render_svg "mark"` |
| `logo-mark.png` | `app/assets/images/` | Navbar/footer `image_tag` (512px) |
| `icon.svg` | `public/` | SVG favicon (meta_tags.rb) |
| `favicon.ico` | `public/` | ICO favicon 16/32/48px |
| `icon.png` | `public/` | PWA manifest (512px) |
| `icon-192.png` | `public/` | PWA manifest |
| `icon-512.png` | `public/` | PWA manifest |
| `apple-touch-icon.png` | `public/` | iOS home screen (meta_tags.rb) |

**Do NOT modify files in `lib/jumpstart/`.** Override by placing files in `app/assets/images/`.

## Workflow

### Step 1: Get or Create SVG

Two paths depending on the source:

**A) From existing PNG/illustration:**
1. Upload to [Recraft AI Vectorizer](https://recraft.ai/vectorizer) (free, best for cartoon/illustration)
2. Download the SVG

Do NOT use vtracer or potrace for complex illustrations — they produce jagged edges.

**B) Hand-coded SVG (simple geometric logos):**
- Use `fill="currentColor"` for dark mode support via Tailwind `fill-current`
- Use fixed hex color for `icon.svg` (favicons cannot inherit CSS)
- Use `viewBox="0 0 24 24"` for consistency

### Step 2: Crop SVG to Square (if needed)

Vectorizers often output wide viewBoxes. Crop to content:

```bash
# Render full SVG, find content bounds
rsvg-convert -w <width> -h <height> input.svg -o full.png
convert full.png -fuzz 5% -format "%@" info:
# Output: WxH+X+Y (e.g., 546x493+495+239)

# Pad to square, center vertically: new_y = Y - (W - H) / 2
sed 's/width="..." height="..." viewBox="..."/width="W" height="W" viewBox="X new_y W W"/' input.svg > square.svg
```

### Step 3: Deploy All Assets

```bash
SVG="public/icon.svg"  # square SVG source of truth

# Copy SVG to all 3 locations
cp "$SVG" app/assets/images/logo.svg
cp "$SVG" app/assets/images/mark.svg

# Generate PNGs (requires rsvg-convert: MacPorts librsvg)
rsvg-convert -w 512 -h 512 "$SVG" -o public/icon-512.png
rsvg-convert -w 512 -h 512 "$SVG" -o public/icon.png
rsvg-convert -w 512 -h 512 "$SVG" -o app/assets/images/logo-mark.png
rsvg-convert -w 192 -h 192 "$SVG" -o public/icon-192.png
rsvg-convert -w 180 -h 180 "$SVG" -o public/apple-touch-icon.png

# Generate favicon.ico (requires ImageMagick: MacPorts ImageMagick)
rsvg-convert -w 512 -h 512 "$SVG" -o /tmp/icon-for-ico.png
convert /tmp/icon-for-ico.png \
  \( -clone 0 -resize 16x16 \) \
  \( -clone 0 -resize 32x32 \) \
  \( -clone 0 -resize 48x48 \) \
  -delete 0 public/favicon.ico

# White-background variant (e.g., Telegram avatar)
rsvg-convert -w 512 -h 512 -b white "$SVG" -o public/app-avatar-white.png
```

Or use the bundled script:
```bash
bash .claude/skills/logo-generator/scripts/generate_favicons.sh public/icon.svg public/
```

### Step 4: Verify

1. Check navbar/footer render correctly with new logo
2. Check browser tab favicon
3. Visit `/icon.svg` directly
4. Preview at multiple sizes with Chrome DevTools MCP
5. Toggle dark mode if using `fill="currentColor"`

## Dependencies

- `rsvg-convert` — MacPorts: `port install librsvg`
- `convert` (ImageMagick) — MacPorts: `port install ImageMagick`
