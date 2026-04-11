class FlashComponent < ViewComponent::Base
  KIND_CLASSES = {
    notice: "text-success bg-success-soft",
    success: "text-success bg-success-soft",
    alert: "text-danger bg-danger-soft",
    error: "text-danger bg-danger-soft"
  }.freeze

  attr_reader :flash

  def initialize(flash:)
    @flash = flash
  end

  def render?
    flash.present?
  end

  def classes_for(kind)
    KIND_CLASSES[kind.to_sym] || KIND_CLASSES[:notice]
  end
end
