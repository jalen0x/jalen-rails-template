require "pp"

module TemplateBase
  class Configuration
    attr_accessor :application_name, :domain, :support_email, :default_from_email

    def self.load!(root: Rails.root)
      config_file = config_path(root:)
      return new unless config_file.exist?

      load config_file
      TemplateBase.config || new
    end

    def self.config_path(root: Rails.root)
      Pathname(root).join("config", "template_base.rb")
    end

    def initialize(options = {})
      @application_name = options.fetch("application_name", "Starter App")
      @domain = options.fetch("domain", "example.test")
      @support_email = options.fetch("support_email", "support@example.test")
      @default_from_email = options.fetch("default_from_email", "Starter App <no-reply@example.test>")
    end

    def save(root: Rails.root)
      File.write(self.class.config_path(root:), <<~RUBY)
        TemplateBase.config = TemplateBase::Configuration.new(#{instance_values.pretty_inspect.strip})
      RUBY
    end
  end
end
