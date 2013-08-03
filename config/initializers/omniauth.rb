OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_CONSUMER_KEY, FACEBOOK_CONSUMER_SECRET, {:scope => "offline_access, publish_stream, user_photos, publish_checkins, photo_upload, publish_actions"}
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
  provider :google_oauth2, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET
end
