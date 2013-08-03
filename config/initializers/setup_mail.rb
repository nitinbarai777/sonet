ActionMailer::Base.smtp_settings = {
  :address              => MAIL_ADDRESS,
  :port                 => MAIL_PORT,
  :domain               => MAIL_DOMAIN,
  :user_name            => MAIL_USER_NAME,
  :password             => MAIL_PASSWORD,
  :authentication       => "plain"
}
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = BASE_URL_DOMAIN