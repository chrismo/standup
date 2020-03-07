# frozen_string_literal: true

module OauthHelpers
  def login(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google,
                             "extra" => { "id_info" => { "email" => user.email } })
    Rails.application.env_config["omniauth.auth"] =
      OmniAuth.config.mock_auth[:google]
    get sessions_path(provider: "google")
  end
end
