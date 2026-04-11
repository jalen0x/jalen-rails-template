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
end
