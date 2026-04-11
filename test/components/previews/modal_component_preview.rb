class ModalComponentPreview < ViewComponent::Preview
  def default
    render(ModalComponent.new(title: "Confirm action")) do
      "Are you sure you want to proceed?".html_safe
    end
  end

  def with_footer
    render(ModalComponent.new(title: "Delete item")) do |c|
      c.with_footer { "Footer slot content".html_safe }
      "This action cannot be undone.".html_safe
    end
  end
end
