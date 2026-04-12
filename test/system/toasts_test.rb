require "application_system_test_case"

class ToastsTest < ApplicationSystemTestCase
  test "manual toast can be dismissed" do
    visit "/?toast_preview=1"

    assert_text "Ship a product, not just a repo skeleton."
    assert_selector "[data-controller='toast']", text: "Dismiss this toast manually."

    find("button[aria-label='Close']").click
    assert_no_text "Dismiss this toast manually."
  end

  test "auto dismiss toast disappears after its timeout" do
    visit "/?toast_preview=1&dismiss_after=1500"

    assert_selector "[data-controller='toast']", text: "Preview toast from the template base."
    assert_no_text "Preview toast from the template base.", wait: 5
  end
end
