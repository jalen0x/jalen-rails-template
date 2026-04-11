class ModalComponent < ViewComponent::Base
  renders_one :header
  renders_one :footer

  attr_reader :title, :size

  SIZES = {
    sm: "max-w-sm",
    md: "max-w-md",
    lg: "max-w-lg",
    xl: "max-w-xl"
  }.freeze

  def initialize(title: nil, size: :md)
    @title = title
    @size = size
  end

  def size_class
    SIZES.fetch(size, SIZES[:md])
  end
end
