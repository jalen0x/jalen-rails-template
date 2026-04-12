class FlashComponent < ViewComponent::Base
  include ToastPositionsHelper

  BANNER_KINDS = {
    notice: {
      container: "border-default bg-neutral-primary text-body",
      badge: "bg-brand-softer text-fg-brand",
      label: "Notice"
    },
    alert: {
      container: "border-danger bg-danger-soft text-heading",
      badge: "bg-danger text-white",
      label: "Alert"
    }
  }.freeze

  attr_reader :flash, :hide_alert

  def initialize(flash:, hide_alert: false)
    @flash = flash
    @hide_alert = hide_alert
  end

  def render?
    banner_messages.any? || toast_messages.any?
  end

  def banner_messages
    @banner_messages ||= begin
      messages = []
      messages << build_banner(:alert, flash[:alert]) if flash[:alert].present? && !flash[:alert].is_a?(Hash) && !hide_alert
      messages << build_banner(:notice, flash[:notice]) if flash[:notice].present? && !flash[:notice].is_a?(Hash)
      messages.compact
    end
  end

  def banner_classes(kind)
    BANNER_KINDS.fetch(kind)[:container]
  end

  def banner_badge_classes(kind)
    BANNER_KINDS.fetch(kind)[:badge]
  end

  def banner_label(kind)
    BANNER_KINDS.fetch(kind)[:label]
  end

  def toast_messages
    @toast_messages ||= flash.each_with_object([]) do |(_, value), toasts|
      next unless value.is_a?(Hash)

      toast = value.with_indifferent_access
      next if toast[:message].blank?

      toasts << {
        message: toast[:message],
        variant: toast[:variant] || toast[:icon_name] || :info,
        position: toast[:position],
        dismissable: toast.fetch(:dismissable, true),
        dismiss_after: toast[:dismiss_after],
        link: toast[:link]
      }
    end
  end

  def toasts_for(position)
    toast_messages.select { |toast| toast_position(toast[:position]) == toast_position(position) }
  end

  private

  def build_banner(kind, message)
    return if message.blank?

    {
      kind:,
      message: message.to_s
    }
  end
end
