require "test_helper"
require_relative "support/with_clues"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include TestSupport::WithClues

  driven_by :rack_test
end

class BrowserSystemTestCase < ApplicationSystemTestCase
  driven_by :selenium, using: ENV.fetch("DRIVER", "headless_chrome").presence&.to_sym || :headless_chrome, screen_size: [ 1400, 1400 ]
end
