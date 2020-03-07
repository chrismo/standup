# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    @settings = {}.tap do |h|
      User.settings_keys.each { |k| h[k] = "" }
    end.merge(current_user.settings)
  end

  def update
    settings_params.first.each_pair do |name, value|
      current_user.settings[name.to_s] = value
      current_user.save!
    end

    redirect_to root_url
  end

  private

  def settings_params
    params.require(:settings)
  end
end
