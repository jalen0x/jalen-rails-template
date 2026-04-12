class FlashComponentPreview < ViewComponent::Preview
  def notice
    render(FlashComponent.new(flash: { notice: "Profile updated successfully" }))
  end

  def alert
    render(FlashComponent.new(flash: { alert: "Something went wrong" }))
  end

  def multiple
    render(FlashComponent.new(flash: {
      notice: "Profile updated",
      alert: "Please verify your email"
    }))
  end

  def with_toasts
    render(FlashComponent.new(flash: {
      notice: "Saved draft",
      billing_warning: {
        message: "Your billing settings need attention.",
        variant: :warning,
        position: "top-right",
        link: { text: "Open billing", url: "/" }
      },
      release_note: {
        message: "A new release is ready.",
        variant: :success,
        dismiss_after: 5_000
      }
    }))
  end
end
