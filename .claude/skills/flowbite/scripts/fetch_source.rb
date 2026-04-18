#!/usr/bin/env ruby
# frozen_string_literal: true

# Adapted from https://github.com/kylefox/flowbite-skills (MIT)
# Fetches/updates the Flowbite source into tmp/flowbite-source/ (gitignored).
#
# Usage:
#   ruby .claude/skills/flowbite/scripts/fetch_source.rb           # latest release tag
#   ruby .claude/skills/flowbite/scripts/fetch_source.rb v4.1.0    # specific tag

require "open-uri"
require "json"
require "fileutils"

PROJECT_ROOT = File.expand_path("../../../..", __dir__)
SOURCE_PATH = File.join(PROJECT_ROOT, "tmp", "flowbite-source")
REPO = "themesberg/flowbite"

def run(cmd, dir: PROJECT_ROOT)
  output = `cd #{dir} && #{cmd} 2>&1`.strip
  unless $?.success?
    warn "  FAILED: #{cmd}"
    warn "  #{output}"
    exit 1
  end
  output
end

def fetch_latest_tag
  puts "Fetching latest release tag from GitHub..."
  tags_json = URI.open("https://api.github.com/repos/#{REPO}/tags?per_page=1").read
  tags = JSON.parse(tags_json)
  tags.first&.dig("name") || abort("No tags found for #{REPO}")
end

def setup_source(tag)
  if Dir.exist?(File.join(SOURCE_PATH, ".git"))
    puts "Source exists. Fetching updates..."
    run("git fetch --tags --quiet", dir: SOURCE_PATH)
  elsif Dir.exist?(SOURCE_PATH)
    warn "#{SOURCE_PATH} exists but is not a git repo."
    warn "Remove it first: rm -rf #{SOURCE_PATH}"
    exit 1
  else
    FileUtils.mkdir_p(File.dirname(SOURCE_PATH))
    puts "Cloning #{REPO}..."
    run("git clone --quiet https://github.com/#{REPO}.git #{SOURCE_PATH}")
  end

  current = `cd #{SOURCE_PATH} && git describe --tags --exact-match 2>/dev/null`.strip
  if current == tag
    puts "Already at #{tag}."
  else
    puts "Checking out #{tag}..."
    run("git checkout --quiet #{tag}", dir: SOURCE_PATH)
    puts "Updated from #{current.empty? ? 'unknown' : current} → #{tag}"
  end
end

def show_doc_summary
  content_dir = File.join(SOURCE_PATH, "content")
  return unless Dir.exist?(content_dir)

  puts "\nSource documentation summary:"
  %w[components forms typography plugins customize].each do |category|
    dir = File.join(content_dir, category)
    next unless Dir.exist?(dir)

    files = Dir.glob(File.join(dir, "*.md")).reject { |f| f.include?("_index") }
    puts "  #{category}: #{files.size} files"
  end
end

# --- Main ---

tag = ARGV[0] || fetch_latest_tag
puts "Target version: #{tag}\n\n"

setup_source(tag)
show_doc_summary

puts "\nDone! Run `ruby .claude/skills/flowbite/scripts/generate_skills.rb` to regenerate skills."
