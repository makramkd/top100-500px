Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fiveHundredPx, ENV['MYFIVEHUNDRED_CONSUMER_KEY'], ENV['MYFIVEHUNDRED_CONSUMER_SECRET']
end