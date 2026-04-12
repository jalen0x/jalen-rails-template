require "test_helper"
require "view_component/test_case"

class FlashComponentTest < ViewComponent::TestCase
  test "renders notice and alert banners" do
    render_inline(FlashComponent.new(flash: { notice: "Saved", alert: "Check your inbox" }))

    assert_text "Saved"
    assert_text "Check your inbox"
    assert_selector "#flash [role='alert']", count: 2
  end

  test "skips alert banner when hide_alert is true" do
    render_inline(FlashComponent.new(flash: { alert: "Inline form error" }, hide_alert: true))

    assert_no_selector "#flash"
  end

  test "groups toasts by position" do
    render_inline(
      FlashComponent.new(
        flash: {
          top_toast: { message: "Top toast", variant: :success },
          bottom_toast: { message: "Bottom toast", variant: :warning, position: "bottom-right" }
        }
      )
    )

    assert_selector "#toasts", text: /Top toast/
    assert_selector "#toasts-bottom-right", text: /Bottom toast/
  end
end
