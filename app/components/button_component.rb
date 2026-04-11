class ButtonComponent < ViewComponent::Base
  VARIANTS = %i[primary secondary danger].freeze

  attr_reader :variant, :type, :href, :options

  def initialize(variant: :primary, type: "button", href: nil, **options)
    raise ArgumentError, "Unknown variant: #{variant}" unless VARIANTS.include?(variant)

    @variant = variant
    @type = type
    @href = href
    @options = options
  end

  def call
    merged = options.merge(class: button_classes)
    if href
      link_to(content, href, **merged)
    else
      tag.button(content, type: type, **merged)
    end
  end

  private

  def button_classes
    base = "box-border font-medium leading-5 rounded-base text-sm px-4 py-2.5 shadow-xs focus:outline-none focus:ring-4"
    user_classes = options[:class]
    [ base, variant_classes, user_classes ].compact.join(" ")
  end

  def variant_classes
    case variant
    when :primary
      "text-white bg-brand border border-transparent hover:bg-brand-strong focus:ring-brand-medium"
    when :secondary
      "text-body bg-neutral-secondary-medium border border-default-medium hover:bg-neutral-tertiary-medium hover:text-heading focus:ring-neutral-tertiary"
    when :danger
      "text-danger bg-neutral-primary border border-danger hover:bg-danger hover:text-white focus:ring-neutral-tertiary"
    end
  end
end
