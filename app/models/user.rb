# frozen_string_literal: true

class User < ApplicationRecord
  has_many :api_keys, foreign_key: "issuer_id", inverse_of: "issuer"

  def self.settings_keys
    %w[name]
  end

  def name
    settings["name"] || default_name
  end

  private

  def default_name
    email.split(/@/).first
  end
end
