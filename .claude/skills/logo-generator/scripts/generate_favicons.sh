#!/usr/bin/env bash
set -euo pipefail

# Generate all favicon/icon files from a source SVG
# Usage: generate_favicons.sh <source.svg> <output_dir>
# Requirements: rsvg-convert (MacPorts: librsvg), ImageMagick 7 (MacPorts: ImageMagick7)

SOURCE_SVG="${1:?Usage: generate_favicons.sh <source.svg> <output_dir>}"
OUTPUT_DIR="${2:-.}"

RSVG_CONVERT="${RSVG_CONVERT:-$(command -v rsvg-convert 2>/dev/null || echo /opt/local/bin/rsvg-convert)}"
MAGICK="${MAGICK:-$(command -v magick 2>/dev/null || echo /opt/local/lib/ImageMagick7/bin/magick)}"

if [[ ! -f "$SOURCE_SVG" ]]; then
  echo "Error: Source SVG not found: $SOURCE_SVG" >&2
  exit 1
fi

if [[ ! -x "$RSVG_CONVERT" ]]; then
  echo "Error: rsvg-convert not found. Install via: sudo port install librsvg" >&2
  exit 1
fi

if [[ ! -x "$MAGICK" ]]; then
  echo "Error: ImageMagick magick not found. Install via: sudo port install ImageMagick7" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Generating PNG icons from $SOURCE_SVG..."
"$RSVG_CONVERT" -w 512 -h 512 "$SOURCE_SVG" -o "$OUTPUT_DIR/icon.png"
"$RSVG_CONVERT" -w 512 -h 512 "$SOURCE_SVG" -o "$OUTPUT_DIR/icon-512.png"
"$RSVG_CONVERT" -w 192 -h 192 "$SOURCE_SVG" -o "$OUTPUT_DIR/icon-192.png"
"$RSVG_CONVERT" -w 180 -h 180 "$SOURCE_SVG" -o "$OUTPUT_DIR/apple-touch-icon.png"

echo "Generating favicon.ico (16/32/48px)..."
"$MAGICK" "$SOURCE_SVG" -define icon:auto-resize=48,32,16 "$OUTPUT_DIR/favicon.ico"

echo "Done. Generated files in $OUTPUT_DIR:"
ls -la "$OUTPUT_DIR"/favicon.ico "$OUTPUT_DIR"/icon*.png "$OUTPUT_DIR"/apple-touch-icon.png
