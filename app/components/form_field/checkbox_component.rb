module FormField
  class CheckboxComponent < ViewComponent::Base
    attr_reader :form, :field, :label, :options

    def initialize(form:, field:, label: nil, **options)
      @form = form
      @field = field
      @label = label
      @options = options
    end

    def label_text
      label || field.to_s.humanize
    end

    def checkbox_classes
      "w-4 h-4 border border-default-medium rounded-xs bg-neutral-secondary-medium focus:ring-2 focus:ring-brand-soft"
    end
  end
end
