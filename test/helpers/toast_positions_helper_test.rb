require "test_helper"

class ToastPositionsHelperTest < ActionView::TestCase
  include ToastPositionsHelper

  test "returns the default position for blank values" do
    assert_equal "top-center", toast_position(nil)
  end

  test "builds stable container ids" do
    assert_equal "toasts", toast_container_id
    assert_equal "toasts-bottom-right", toast_container_id("bottom-right")
  end

  test "raises on invalid positions" do
    assert_raises(ArgumentError) { toast_position("middle") }
  end
end
