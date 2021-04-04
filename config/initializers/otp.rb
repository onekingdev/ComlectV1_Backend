require 'otp'
require 'otp/mailer'

OTP::Mailer.default subject: 'Verify your login'
OTP::Mailer.default from: "Complect <#{ENV.fetch('DEFAULT_MAIL_FROM')}>"
OTP::Mailer.prepend_view_path(Rails.root.join('app', 'views'))
