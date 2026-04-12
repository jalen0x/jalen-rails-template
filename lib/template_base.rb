module TemplateBase
  ROOT = Pathname(__dir__).join("template_base").freeze
end

require_relative "template_base/configuration"
require_relative "template_base/project_setup"
require_relative "template_base/engine"

module TemplateBase
  def self.root
    ROOT
  end

  def self.config
    @config ||= Configuration.load!
  end

  def self.config=(value)
    @config = value
  end
end
