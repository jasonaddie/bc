if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address              => ENV['APPLICATION_EMAIL_SMTP_ADDRESS'],
    :port                 => 587,
    :domain               => ENV['APPLICATION_EMAIL_DOMAIN'],
    :user_name            => ENV['APPLICATION_FEEDBACK_FROM_EMAIL'],
    :password             => ENV['APPLICATION_FEEDBACK_FROM_PWD'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
end