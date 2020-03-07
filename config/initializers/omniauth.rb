# frozen_string_literal: true

google_client_id = ENV.fetch(
  "GOOGLE_CLIENT_ID",
  "28967537447-4r0f1f1gr1gi0mv1g4h49okobschhljd.apps.googleusercontent.com"
)
google_client_secret = ENV.fetch(
  "GOOGLE_CLIENT_SECRET",
  "vxXBiUKW3mNWsDjWBUXXfZN_"
)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_client_id, google_client_secret,
           scope: "email, profile",
           prompt: "select_account"
end
