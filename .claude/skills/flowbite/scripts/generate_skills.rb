#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a single flowbite skill with all components as references.
# Output layout:
#   .claude/skills/flowbite/
#     SKILL.md
#     references/{components,forms,typography,plugins,customize}/*.md
#
# Usage:
#   ruby .claude/skills/flowbite/scripts/generate_skills.rb

require "fileutils"
require_relative "clean_docs"

PROJECT_ROOT = File.expand_path("../../../..", __dir__)
SOURCE_BASE = File.join(PROJECT_ROOT, "tmp", "flowbite-source", "content")
SKILL_DIR = File.expand_path("..", __dir__)
REFS_DIR = File.join(SKILL_DIR, "references")

CATEGORIES = %w[components forms typography plugins customize].freeze

def clean_category(cleaner, category)
  source_dir = File.join(SOURCE_BASE, category)
  return [] unless Dir.exist?(source_dir)

  dest_dir = File.join(REFS_DIR, category)
  FileUtils.mkdir_p(dest_dir)

  entries = []
  Dir.glob(File.join(source_dir, "*.md")).reject { |f| File.basename(f).start_with?("_") }.sort.each do |source_path|
    result = cleaner.clean_file(source_path)
    basename = File.basename(source_path, ".md")
    File.write(File.join(dest_dir, "#{basename}.md"), result[:content])
    entries << { title: result[:title], description: result[:description], path: "references/#{category}/#{basename}.md" }
  end
  entries
end

def build_table(entries)
  rows = entries.map { |e| "| #{e[:title]} | `#{e[:path]}` |" }
  [ "| Component | Reference |", "|-----------|-----------|", *rows ].join("\n")
end

def generate_skill_md(sections)
  component_triggers = %w[
    flowbite accordion alert avatar badge banner breadcrumb button card carousel
    chat-bubble clipboard datepicker drawer dropdown footer gallery indicator
    jumbotron kbd list-group mega-menu modal navbar pagination popover progress
    rating sidebar skeleton speed-dial spinner stepper table tabs timeline toast
    tooltip typography video input textarea checkbox radio toggle range select
    chart datatable wysiwyg
  ].join(", ")

  body = +<<~MD
    ---
    name: flowbite
    description: "Flowbite UI component library reference. Use when writing HTML/Tailwind for Flowbite components, forms, typography, plugins, or customizing theme/dark mode/colors/RTL. Triggers: #{component_triggers}"
    ---

    # Flowbite

    Flowbite is a free and open-source UI component library built on top of Tailwind CSS. It provides ready-to-use HTML components with data attributes to enable interactive elements.

    **Usage**: When implementing a component, read the matching reference file below. All references are plain markdown with HTML code blocks.

    ## Project constraints

    - **Custom JS**: write a Stimulus controller in `app/javascript/controllers/`. No inline `<script>` tags.
    - **Modals**: open a modal by putting `data: { turbo_frame: "modal_content" }` on the TRIGGERING link (from a normal page). The target view wraps in `turbo_frame_tag "modal_content"` ONLY when `turbo_frame_request?` is true (so the same view still works as a standalone page). For links/forms placed INSIDE the modal that should stay in it, use the context-aware `data: modal_turbo_frame_data` helper (returns `{ turbo_frame: "modal_content" }` in a modal, `{}` on a full page).
    - **Forms**: use Rails `form_with` / `f.text_field` helpers, preserving Flowbite Tailwind classes on each field. Don't paste raw `<form>` / `<input>` HTML.
    - **Copy**: never hardcode user-facing strings — use `t(".key")` (lazy lookup) and update both `en.yml` and `zh-CN.yml`.

    ## Regenerating

    ```bash
    ruby .claude/skills/flowbite/scripts/fetch_source.rb
    ruby .claude/skills/flowbite/scripts/generate_skills.rb
    ```

    Source clones to `tmp/flowbite-source/` (gitignored).

  MD

  sections.each do |category, entries|
    next if entries.empty?

    body << "## #{category.capitalize} (#{entries.size})\n\n"
    body << build_table(entries)
    body << "\n\n"
  end

  body
end

# --- Main ---

FileUtils.rm_rf(REFS_DIR)
FileUtils.mkdir_p(REFS_DIR)

cleaner = CleanDocs.new
sections = {}

CATEGORIES.each do |category|
  print "  cleaning #{category}... "
  sections[category] = clean_category(cleaner, category)
  puts "#{sections[category].size} files"
end

File.write(File.join(SKILL_DIR, "SKILL.md"), generate_skill_md(sections))

total = sections.values.sum(&:size)
puts "\nDone! Wrote SKILL.md + #{total} reference files under #{REFS_DIR}/"
