#!/usr/bin/env ruby
# frozen_string_literal: true

# PreToolUse hook — runs BEFORE Edit/Write/Bash land on disk.
#
# Guards:
#   - Protected paths (lib/template_base/, credentials, schema, builds)
#   - Bash safety (force-push main, piped test output, assets:precompile)
#
# Policy checks (simulate edit result, then scan):
#   - Hardcoded Tailwind color palette utilities (use Flowbite semantic classes)
#   - Physical LTR utilities (use logical RTL-safe utilities)
#   - dark: overrides (Flowbite handles dark mode)
#   - h-screen (use h-dvh)
#   - discard_on in jobs (except discard_on RecordNotFound / DeserializationError)
#   - .destroy on User (use .discard)
#   - Override files missing Override comment

require "json"
require "pathname"
require "shellwords"

PROJECT_DIR = ENV["CLAUDE_PROJECT_DIR"] || Dir.pwd
IGNORED_PREFIXES = [ "app/assets/builds/", "node_modules/", "tmp/", "vendor/" ].freeze
UI_PREFIXES = [ "app/views/", "app/javascript/", "app/assets/tailwind/", "lib/template_base/app/views/", "lib/template_base/app/javascript/" ].freeze
RUBY_POLICY_PREFIXES = [ "app/", "config/", "test/", "lib/" ].freeze
HARD_CODED_COLOR_PATTERN = /\b(?:bg|text|border|ring|from|via|to|stroke|fill|decoration|outline)-(?:gray|blue|green|red|yellow|indigo|purple|pink|primary)-\d{2,3}\b/
PHYSICAL_MARGIN_PADDING_PATTERN = /\b(?:m[lr]|p[lr])-\d+(?:\.\d+)?\b|\btext-(?:left|right)\b/
PHYSICAL_POSITION_PATTERN = /\b(?:left|right)-\d+(?:\.\d+)?\b|\b(?:left|right)-\[\S+\]\b/
DARK_HARDCODED_COLOR_PATTERN = /\bdark:(?:bg|text|border|ring|from|via|to|stroke|fill|decoration|outline)-(?:gray|blue|green|red|yellow|indigo|purple|pink|primary)-\d{2,3}\b/


def parse_payload
  raw = STDIN.read
  return nil if raw.strip.empty?

  JSON.parse(raw)
rescue JSON::ParserError
  nil
end


def relative_path(path)
  return "" if path.to_s.empty?

  pathname = Pathname.new(path)
  absolute = pathname.absolute? ? pathname.cleanpath : Pathname.new(File.expand_path(path, PROJECT_DIR))
  rel = absolute.relative_path_from(Pathname.new(PROJECT_DIR)).to_s
  # Paths outside the project directory start with ".." — return nil to skip
  return nil if rel.start_with?("..")
  rel
rescue ArgumentError
  path.to_s
end


def block(reason)
  puts JSON.generate({ "decision" => "block", "reason" => reason })
end


# True when working in the template repo itself — editing lib/template_base/ is allowed here.
# Apps that consume the template should override into app/ instead.
def template_base_project?
  File.basename(PROJECT_DIR).match?(/template/i)
end


def protected_edit_reason(path)
  case path
  when %r{\Alib/template_base/}
    return if template_base_project?

    "Do not modify `lib/template_base/`. Copy the file into `app/` (use `rails g template_base:override <path>`) and override it there so template_base updates remain safe."
  when %r{\Aconfig/master\.key\z}, %r{\Aconfig/credentials\.yml\.enc\z}, %r{\Aconfig/credentials/.*\.key\z}
    "Do not edit encrypted credentials or keys from Claude. Use `bin/rails credentials:edit` manually instead."
  when %r{\Aconfig/credentials/.*\.yml\.enc\z}
    "This project uses only `config/credentials.yml.enc`. Do not create or edit environment-specific encrypted credentials files."
  when %r{\Aapp/assets/builds/}
    "Do not edit generated assets in `app/assets/builds/`. Change the source files under `app/assets/tailwind/` or `app/assets/javascripts/` instead."
  when %r{\Adb/(?:schema|cache_schema|cable_schema|queue_schema)\.rb\z}
    "Do not edit generated schema files directly. Change migrations or queue/cable/cache config, then regenerate the schema."
  end
end


def current_branch
  branch = `git branch --show-current 2>/dev/null`
  branch.to_s.strip
end


def protected_force_push?(command)
  tokens = Shellwords.split(command)
  return false unless tokens[0] == "git" && tokens[1] == "push"

  force = tokens.any? do |token|
    token == "--force" ||
      token.start_with?("--force=") ||
      token == "--force-with-lease" ||
      token.start_with?("--force-with-lease=") ||
      token.match?(/\A-[A-Za-z]*f[A-Za-z]*\z/)
  end
  return false unless force

  explicit_target = tokens.any? do |token|
    token.match?(%r{\A(?:origin/)?(?:main|master)\z}) ||
      token.match?(%r{(?:^|:)(?:refs/heads/)?(?:main|master)\z})
  end

  implicit_target = %w[main master].include?(current_branch) &&
    tokens.none? { |token| token.include?(":") || token.match?(%r{\Aorigin/}) }

  explicit_target || implicit_target
rescue ArgumentError
  false
end


def piped_test_output?(command)
  command.match?(%r{\b(?:bin/rails\s+test(?::system)?|bin/rubocop|bundle\s+exec\s+erb_lint)\b.*\|\s*cat\b})
end


def assets_precompile?(command)
  command.match?(/\b(?:bin\/rails|rails|rake)\s+assets:precompile\b/)
end


def ui_source?(path)
  UI_PREFIXES.any? { |prefix| path.start_with?(prefix) }
end


def ruby_policy_path?(path)
  RUBY_POLICY_PREFIXES.any? { |prefix| path.start_with?(prefix) }
end


def ignored_path?(path)
  IGNORED_PREFIXES.any? { |prefix| path.start_with?(prefix) }
end


# Direct .destroy on soft-delete model: user.destroy, User.find(1).destroy, @user.destroy!
# Does NOT match: current_user.tokens.find_by(...).destroy (intermediate chain)
SOFT_DELETE_DIRECT = /\b(?:User|user|@user)\b(?:\.\w+(?:\([^)]*\))?)*\.destroy[!]?\b/

def soft_delete_issue(path, content)
  return nil unless path.end_with?(".rb") && ruby_policy_path?(path)
  return nil if path.start_with?("test/")  # tests legitimately use .destroy for cleanup
  return nil unless content.match?(SOFT_DELETE_DIRECT)

  "`User` is soft-deleted with `.discard`, not `.destroy`."
end


def override_comment_issue(path, content)
  return nil unless path.start_with?("app/")

  lib_path = "lib/template_base/#{path}"
  return nil unless File.exist?(File.expand_path(lib_path, PROJECT_DIR))
  return nil if content.match?(/Override:\s*lib\/template_base\//)

  "This file overrides `#{lib_path}`. Add an Override comment with changes description at file top."
end


def policy_issues(path, content)
  issues = []

  override_issue = override_comment_issue(path, content)
  issues << override_issue if override_issue

  if path.end_with?(".rb") && ruby_policy_path?(path)
    allowed_discard = %w[ActiveRecord::RecordNotFound ActiveJob::DeserializationError]
    # Join continuation lines (lines ending with comma or starting with whitespace after discard_on)
    joined = content.gsub(/\bdiscard_on\b.*?(?=\n\s*(?:def |end\b|retry_on|discard_on|queue_as|[a-z_]+\s)|\z)/m) { |m| m.gsub("\n", " ") }
    has_bad_discard = joined.lines.any? do |line|
      next false unless line.match?(/\bdiscard_on\b/)
      next false if line.match?(/^\s*#/)  # skip comments
      args = line.sub(/^\s*discard_on\s+/, "").strip
      # Remove keyword arguments (if:, unless:, report:, wait:, etc.)
      args = args.gsub(/\b\w+:\s*\S+/, "").gsub(/\b\w+:\s*$/, "")
      exceptions = args.split(",").map(&:strip).reject(&:empty?)
      (exceptions - allowed_discard).any?
    end
    issues << "`discard_on` is forbidden for Solid Queue jobs, except for `ActiveRecord::RecordNotFound` and `ActiveJob::DeserializationError`. Let other jobs fail so retries and debugging still work." if has_bad_discard
    issues << "Rails 8.1+ uses `wait: :polynomially_longer`, not `:exponentially_longer`." if content.match?(/\bexponentially_longer\b/)
  end

  if ui_source?(path)
    colors = content.scan(HARD_CODED_COLOR_PATTERN).uniq.first(5)
    issues << "Use Flowbite semantic classes instead of hardcoded Tailwind palette utilities: #{colors.join(', ')}." if colors.any?

    # ml/mr/pl/pr/text-left/text-right — always flagged
    physical = content.scan(PHYSICAL_MARGIN_PADDING_PATTERN)
    # left-*/right-* — only flagged when no fixed/absolute in surrounding context
    # (check 3-line window to handle multiline class attributes)
    lines = content.lines
    lines.each_with_index do |line, i|
      start_idx = [ i - 1, 0 ].max
      end_idx = [ i + 1, lines.size - 1 ].min
      next if (start_idx..end_idx).any? { |j| lines[j].match?(/\b(?:fixed|absolute)\b/) }
      physical.concat(line.scan(PHYSICAL_POSITION_PATTERN))
    end
    physical = physical.uniq.first(5)
    issues << "Use logical RTL utilities instead of physical left/right utilities: #{physical.join(', ')}." if physical.any?

    dark_colors = content.scan(DARK_HARDCODED_COLOR_PATTERN).uniq.first(5)
    issues << "Avoid `dark:` with hardcoded palette colors. Use Flowbite semantic variables: #{dark_colors.join(', ')}." if dark_colors.any?
    issues << "Use `h-dvh` instead of `h-screen` to avoid mobile browser viewport bugs." if content.match?(/\bh-screen\b/)
  end

  destroy_issue = soft_delete_issue(path, content)
  issues << destroy_issue if destroy_issue
  issues
end


def simulate_content(path, input, tool_name)
  absolute_path = File.expand_path(path, PROJECT_DIR)

  case tool_name
  when "Write"
    input["content"].to_s
  when "Edit"
    return nil unless File.file?(absolute_path)

    current = File.read(absolute_path)
    old_string = input["old_string"].to_s
    new_string = input["new_string"].to_s
    if input["replace_all"]
      current.gsub(old_string, new_string)
    else
      current.sub(old_string, new_string)
    end
  end
end


payload = parse_payload
exit 0 unless payload

tool_name = payload["tool_name"].to_s
input = payload["tool_input"] || {}

case tool_name
when "Edit", "Write"
  path = relative_path(input["file_path"])
  exit 0 if path.nil?
  reason = protected_edit_reason(path)
  block(reason) if reason

  unless reason || ignored_path?(path)
    content = simulate_content(path, input, tool_name)
    if content
      issues = policy_issues(path, content)
      block("Policy violation in `#{path}`:\n#{issues.map { |i| "- #{i}" }.join("\n")}") if issues.any?
    end
  end
when "Bash"
  command = input["command"].to_s

  if protected_force_push?(command)
    block("`git push --force` to `main` or `master` is blocked. Push a branch or use a safer non-force flow instead.")
  elsif piped_test_output?(command)
    block("Do not pipe test or lint output into `cat`. Run the command directly so failures stay visible.")
  elsif assets_precompile?(command)
    block("`assets:precompile` in development leaves compiled files in `public/assets/` that shadow live CSS changes. Use `bin/dev` for development. If you already precompiled, run `bin/rails assets:clobber` to clean up.")
  end
end
