# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

gem "bootsnap", ">= 1.1.0", require: false
gem "jbuilder", "~> 2.5"
gem "octokit"
gem "pg", ">= 0.18", "< 2.0"
gem "pry-rails"
gem "puma", "~> 3.12.2"
gem "rails", "~> 5.2.4.1"
gem "sass-rails", "~> 5.0"
gem "tablesmith"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"

gem "chronic"
gem "kaminari"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rails"

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "rspec-rails"
  gem "spring"
  gem "spring-commands-rspec"
  gem "timecop"
end
