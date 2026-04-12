class ApplicationMailer < ActionMailer::Base
  default from: -> { TemplateBase.config.default_from_email }
  layout "mailer"
end
