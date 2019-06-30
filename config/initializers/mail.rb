ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: ENV['APP_MAIL_ADDRESS'],
  password: ENV['APP_MAIL_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}