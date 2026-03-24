class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_USERNAME', 'noreply@boardiq.app')
  layout 'mailer'
end
