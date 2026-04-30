#!/usr/bin/env ruby
# frozen_string_literal: true

# Auto-format files after Edit/Write/apply_patch.
# Runs erb_lint --autocorrect for ERB, rubocop -A for Ruby.
# Formatting is best-effort — failures are silently ignored.

require "json"
require "pathname"
require "open3"

PROJECT_DIR = ENV["CLAUDE_PROJECT_DIR"] || Dir.pwd
IGNORED_PREFIXES = [ "app/assets/builds/", "node_modules/", "tmp/", "vendor/" ].freeze

def parse_payload
  raw = STDIN.read
  return nil if raw.strip.empty?

  JSON.parse(raw)
rescue JSON::ParserError
  nil
end


def relative_path(path)
  return nil if path.to_s.empty?

  pathname = Pathname.new(path)
  absolute = pathname.absolute? ? pathname.cleanpath : Pathname.new(File.expand_path(path, PROJECT_DIR))
  absolute.relative_path_from(Pathname.new(PROJECT_DIR)).to_s
rescue ArgumentError
  path.to_s
end


def ignored_path?(path)
  IGNORED_PREFIXES.any? { |prefix| path.start_with?(prefix) }
end


def run_with_mise(*command)
  lockfile = File.join(PROJECT_DIR, "Gemfile.lock")
  lockfile_content = File.file?(lockfile) ? File.binread(lockfile) : nil

  Open3.capture3("mise", "exec", "ruby", "--", *command, chdir: PROJECT_DIR)
ensure
  File.binwrite(lockfile, lockfile_content) if lockfile_content
end


def format_file(path)
  absolute_path = File.expand_path(path, PROJECT_DIR)
  return unless File.file?(absolute_path)

  case File.extname(path)
  when ".erb"
    run_with_mise("bundle", "exec", "erb_lint", "--autocorrect", path)
  when ".rb"
    run_with_mise("bin/rubocop", "-A", "--fail-level", "fatal", path)
  end
rescue StandardError
  nil
end


def apply_patch_section_header?(line)
  line.start_with?("*** Add File:", "*** Update File:", "*** Delete File:", "*** End Patch")
end


def apply_patch_changed_paths(command)
  lines = command.lines(chomp: true)
  return [] unless lines.first == "*** Begin Patch"

  paths = []
  index = 1

  while index < lines.length
    line = lines[index]

    case line
    when /\A\*\*\* Add File: (.+)\z/
      paths << Regexp.last_match(1)
      index += 1
    when /\A\*\*\* Update File: (.+)\z/
      path = Regexp.last_match(1)
      index += 1
      move_path = nil

      while index < lines.length && !apply_patch_section_header?(lines[index])
        if (match = lines[index].match(/\A\*\*\* Move to: (.+)\z/))
          move_path = match[1]
        end

        index += 1
      end

      paths << (move_path || path)
    when /\A\*\*\* Delete File:/
      index += 1
    else
      index += 1
    end
  end

  paths
end


def payload_paths(payload)
  if payload["tool_name"].to_s == "apply_patch"
    apply_patch_changed_paths(payload.dig("tool_input", "command").to_s)
  else
    [ payload.dig("tool_input", "file_path") || payload.dig("tool_response", "filePath") ]
  end
end


payload = parse_payload
exit 0 unless payload

payload_paths(payload).uniq.each do |raw_path|
  path = relative_path(raw_path)
  next if path.nil? || ignored_path?(path)

  format_file(path)
end
