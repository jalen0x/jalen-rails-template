class ToastComponentPreview < ViewComponent::Preview
  def success
    render(ToastComponent.new(message: "Profile updated", variant: :success, dismiss_after: 5_000))
  end

  def warning_with_link
    render(
      ToastComponent.new(
        message: "Your billing settings need attention.",
        variant: :warning,
        link: { text: "Review settings", url: "/" }
      )
    )
  end
end
