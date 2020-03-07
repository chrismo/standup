# frozen_string_literal: true

google_client_id = ENV["GOOGLE_CLIENT_ID"] || ENV["STANDUP_DEV_GOOGLE_CLIENT_ID"]
google_client_secret = ENV["GOOGLE_CLIENT_SECRET"] || ENV["STANDUP_DEV_GOOGLE_CLIENT_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, google_client_id, google_client_secret,
           scope: "email, profile",
           prompt: "select_account"
end
