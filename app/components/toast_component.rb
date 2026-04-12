class ToastComponent < ViewComponent::Base
  include ToastPositionsHelper

  VARIANTS = {
    info: {
      badge: "bg-brand-softer text-fg-brand",
      link: "text-fg-brand"
    },
    success: {
      badge: "bg-success-soft text-fg-success",
      link: "text-fg-success"
    },
    warning: {
      badge: "bg-warning-soft text-fg-warning",
      link: "text-fg-warning"
    },
    danger: {
      badge: "bg-danger-soft text-fg-danger",
      link: "text-fg-danger"
    }
  }.freeze

  attr_reader :dismiss_after, :dismissable, :message, :position

  def initialize(message:, variant: :info, position: nil, dismissable: true, dismiss_after: nil, link: nil)
    @message = message.to_s
    @variant = normalize_variant(variant)
    @position = toast_position(position)
    @dismissable = dismissable
    @dismiss_after = dismiss_after.to_i
    @link = normalize_link(link)
  end

  def variant
    @variant
  end

  def badge_classes
    VARIANTS.fetch(variant)[:badge]
  end

  def link_classes
    "text-sm font-medium hover:underline #{VARIANTS.fetch(variant)[:link]}"
  end

  def link
    @link
  end

  def aria_live
    variant == :danger ? "assertive" : "polite"
  end

  private

  def normalize_variant(value)
    normalized = value.to_s.presence || "info"
    normalized = "danger" if normalized == "error"
    normalized = normalized.to_sym
    return normalized if VARIANTS.key?(normalized)

    raise ArgumentError, "Unknown toast variant: #{value.inspect}"
  end

  def normalize_link(value)
    return if value.blank?
    return unless value.is_a?(Hash)

    text = value[:text].presence || value["text"].presence
    url = value[:url].presence || value["url"].presence
    return if text.blank? || url.blank?

    { text:, url: }
  end
end
