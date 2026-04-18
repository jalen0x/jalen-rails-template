#!/usr/bin/env ruby
# frozen_string_literal: true

# Cleans Flowbite Hugo source docs into plain markdown suitable for skill references.
# Strips YAML frontmatter, Hugo shortcodes, and navigation metadata while preserving
# all HTML examples, markdown headings, and content.
#
# Usage:
#   require_relative 'clean_docs'
#   cleaner = CleanDocs.new
#   result = cleaner.clean_file("path/to/source.md")
#   # result => { title: "Modal", description: "...", content: "..." }

class CleanDocs
  # Clean a source .md file and return structured result
  def clean_file(path)
    raw = File.read(path)
    frontmatter, body = extract_frontmatter(raw)

    title = extract_title(frontmatter)
    description = extract_description(frontmatter)
    requires_js = frontmatter.match?(/requires_js:\s*true/)

    cleaned = clean_body(body)

    {
      title: title,
      description: description,
      requires_js: requires_js,
      content: "# #{title}\n\n#{description}\n\n#{cleaned}".strip,
      headings: extract_h2_headings(cleaned)
    }
  end

  private

  # Split YAML frontmatter from body content
  def extract_frontmatter(raw)
    if raw.start_with?("---")
      parts = raw.split("---", 3)
      [ parts[1] || "", parts[2] || "" ]
    else
      [ "", raw ]
    end
  end

  def extract_title(frontmatter)
    if (match = frontmatter.match(/title:\s*(.+?)(?:\s*-\s*Flowbite)?\s*$/))
      match[1].strip.sub(/\ATailwind CSS\s+/, "")
    else
      "Unknown Component"
    end
  end

  def extract_description(frontmatter)
    if (match = frontmatter.match(/description:\s*(.+)/))
      match[1].strip
    else
      ""
    end
  end

  def clean_body(body)
    text = body.dup

    # Strip Hugo example shortcodes — keep inner HTML as html code blocks.
    # Multiline-aware to handle backtick-quoted args like `javascript=`...\n...`>}}`.
    text.gsub!(/\{\{<\s*example\b.*?>\}\}\s*\n?/m, "```html\n")
    text.gsub!(/\{\{<\s*\/example\s*>\}\}\s*\n?/, "```\n\n")

    # Strip Hugo code shortcodes — extract lang attribute for fenced code blocks
    text.gsub!(/\{\{<\s*code\s+(?:[^>]*?)lang="([^"]*)"[^>]*>\}\}\s*\n?/) { "```#{$1}\n" }
    # Fallback for code shortcodes without lang attribute
    text.gsub!(/\{\{<\s*code\b[^>]*>\}\}\s*\n?/, "```\n")
    text.gsub!(/\{\{<\s*\/code\s*>\}\}\s*\n?/, "```\n\n")

    # Replace {{< param homepage >}} with actual URL
    text.gsub!(/\{\{<\s*param\s+homepage\s*>\}\}/, "https://flowbite.com")

    # Replace {{< current_version >}} with placeholder
    text.gsub!(/\{\{<\s*current_version\s*>\}\}/, "latest")

    # Strip {{< ref "..." >}} — keep just the path as a reference
    text.gsub!(/\{\{<\s*ref\s+"([^"]+)"\s*>\}\}/, '/docs/\1')

    # Strip any remaining Hugo shortcodes we haven't caught
    text.gsub!(/\{\{<[^>]*>\}\}/, "")

    # Drop sections irrelevant to our stack (Rails/Hotwire + ImportMaps, no TS/npm,
    # no React/Vue). JS API is KEPT — needed when writing Stimulus controllers.
    text.gsub!(SECTIONS_TO_DROP, "")

    # Clean up excessive blank lines (3+ → 2)
    text.gsub!(/\n{3,}/, "\n\n")

    text.strip
  end

  SECTIONS_TO_DROP = /
    ^\#\#\s+
    (?:
      TypeScript(?:\s+\S.*)?|
      Getting\ started|
      Installation|
      Setup|
      Using\ (?:with|in)\s+\S.*
    )
    \b.*?
    (?=^\#\#\s|\z)
  /mx

  # Extract ## headings for variant listing in SKILL.md
  def extract_h2_headings(content)
    content.scan(/^## (.+)$/).flatten
  end
end

# CLI mode: clean a single file and print to stdout
if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    warn "Usage: ruby clean_docs.rb <source_file.md>"
    exit 1
  end

  cleaner = CleanDocs.new
  result = cleaner.clean_file(ARGV[0])
  puts result[:content]
end
