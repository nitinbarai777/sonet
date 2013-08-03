OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, LINKEDIN_CONSUMER_KEY, LINKEDIN_CONSUMER_SECRET, { :scope => "r_basicprofile r_fullprofile r_emailaddress r_contactinfo", :fields=> ["id", "email-address", "first-name", "last-name", "headline", "picture-url", "public-profile-url", "location"] }
end
