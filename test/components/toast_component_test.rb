require "test_helper"
require "view_component/test_case"

class ToastComponentTest < ViewComponent::TestCase
  test "renders all supported variants" do
    %i[info success warning danger].each do |variant|
      render_inline(ToastComponent.new(message: "#{variant} toast", variant: variant))
      assert_text "#{variant} toast"
    end
  end

  test "renders optional link and close button" do
    render_inline(
      ToastComponent.new(
        message: "Review your profile",
        variant: :info,
        link: { text: "Open profile", url: "/profile" }
      )
    )

    assert_link "Open profile", href: "/profile"
    assert_selector "button[data-action='toast#close']"
  end

  test "can omit dismiss button" do
    render_inline(ToastComponent.new(message: "Pinned", dismissable: false))

    assert_no_selector "button[data-action='toast#close']"
  end

  test "defaults to the shared toast container position" do
    component = ToastComponent.new(message: "Default toast")

    assert_equal "top-center", component.position
  end

  test "raises for an invalid position" do
    assert_raises(ArgumentError) do
      ToastComponent.new(message: "Broken", position: "middle")
    end
  end
end
