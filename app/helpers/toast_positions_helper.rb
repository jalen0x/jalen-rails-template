module ToastPositionsHelper
  TOAST_POSITIONS = %w[
    top-left
    top-center
    top-right
    bottom-left
    bottom-center
    bottom-right
  ].freeze

  DEFAULT_TOAST_POSITION = "top-center"

  def toast_positions
    TOAST_POSITIONS
  end

  def toast_position(position)
    return DEFAULT_TOAST_POSITION if position.blank?

    normalized = position.to_s
    return normalized if TOAST_POSITIONS.include?(normalized)

    raise ArgumentError, "Invalid toast position: #{normalized.inspect}. Allowed: #{TOAST_POSITIONS.join(', ')}"
  end

  def toast_container_id(position = nil)
    normalized = toast_position(position)
    normalized == DEFAULT_TOAST_POSITION ? "toasts" : "toasts-#{normalized}"
  end

  def toast_container_classes(position)
    base = "pointer-events-none fixed z-50 flex w-[min(100vw-2rem,24rem)] flex-col gap-3"

    case toast_position(position)
    when "top-left"
      "#{base} left-4 top-4 items-start"
    when "top-center"
      "#{base} left-1/2 top-4 -translate-x-1/2 items-stretch"
    when "top-right"
      "#{base} right-4 top-4 items-end"
    when "bottom-left"
      "#{base} bottom-4 left-4 items-start"
    when "bottom-center"
      "#{base} bottom-4 left-1/2 -translate-x-1/2 items-stretch"
    when "bottom-right"
      "#{base} bottom-4 right-4 items-end"
    end
  end
end
