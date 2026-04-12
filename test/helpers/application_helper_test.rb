require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "returns modal frame data inside a turbo frame request" do
    def turbo_frame_request? = true

    assert_equal({ turbo_frame: "modal_content" }, modal_turbo_frame_data)
  end

  test "returns empty hash on full page requests" do
    def turbo_frame_request? = false

    assert_equal({}, modal_turbo_frame_data)
  end
end
