require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: ENV.fetch("DRIVER", "headless_chrome").presence&.to_sym || :headless_chrome, screen_size: [ 1400, 1400 ]
end
