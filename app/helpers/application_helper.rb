module ApplicationHelper
  # Returns data attributes for turbo frame modal.
  # When request comes from a turbo frame, returns { turbo_frame: "modal_content" }
  # Otherwise returns empty hash for normal navigation.
  def modal_turbo_frame_data
    turbo_frame_request? ? { turbo_frame: "modal_content" } : {}
  end

  # Returns a smart back URL that prioritizes HTTP referer with same-origin
  # checks, falling back to the provided path when no valid referer exists.
  def smart_back_url(fallback_path = root_path)
    referer = request.referer
    valid_referer?(referer) ? referer : fallback_path
  end

  private

  def valid_referer?(referer)
    return false if referer.blank?
    return false if referer == request.url

    URI.parse(referer).host == request.host
  rescue URI::InvalidURIError
    false
  end
end
