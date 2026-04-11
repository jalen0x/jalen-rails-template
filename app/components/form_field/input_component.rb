module FormField
  class InputComponent < ViewComponent::Base
    attr_reader :form, :field, :label, :type, :placeholder, :options

    def initialize(form:, field:, label: nil, type: :text, placeholder: nil, **options)
      @form = form
      @field = field
      @label = label
      @type = type
      @placeholder = placeholder
      @options = options
    end

    def label_text
      label || field.to_s.humanize
    end

    def input_classes
      "bg-neutral-secondary-medium border border-default-medium text-heading text-sm rounded-base focus:ring-brand focus:border-brand block w-full px-3 py-2.5 shadow-xs placeholder:text-body"
    end
  end
end
