# frozen_string_literal: true

Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create", as: "sessions"
  get "/login", to: "sessions#index", as: "login"
  get "/logout", to: "sessions#destroy"

  root "standup#index"

  get "standup", to: "standup#index"
  post "standup", to: "standup#mass_update"

  scope "standup" do
    get "week_detail", to: "standup#week_detail"
    get "week_summary", to: "standup#week_summaries"
    get "planning", to: "standup#planning"
  end

  namespace "api" do
    resources :standup_categories, only: [:index]
    resources :standup_items, only: %i[index create]
  end

  resources "api_keys", only: %i[index create destroy]
end
