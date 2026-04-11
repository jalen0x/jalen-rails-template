class ButtonComponentPreview < ViewComponent::Preview
  # @param variant [Symbol] select { choices: [primary, secondary, danger] }
  # @param label [String]
  def default(variant: :primary, label: "Click me")
    render(ButtonComponent.new(variant: variant)) { label }
  end

  def primary
    render(ButtonComponent.new(variant: :primary)) { "Save changes" }
  end

  def secondary
    render(ButtonComponent.new(variant: :secondary)) { "Cancel" }
  end

  def danger
    render(ButtonComponent.new(variant: :danger)) { "Delete" }
  end

  def as_link
    render(ButtonComponent.new(variant: :primary, href: "#")) { "Go to dashboard" }
  end
end
