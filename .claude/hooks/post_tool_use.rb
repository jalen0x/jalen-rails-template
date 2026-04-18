#!/usr/bin/env ruby
# frozen_string_literal: true

# Auto-format files after Edit/Write.
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
  Open3.capture3("mise", "exec", "ruby", "--", *command, chdir: PROJECT_DIR)
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


payload = parse_payload
exit 0 unless payload

path = relative_path(payload.dig("tool_input", "file_path") || payload.dig("tool_response", "filePath"))
exit 0 if path.nil? || ignored_path?(path)

format_file(path)
