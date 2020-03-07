# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :issuer, class_name: "User"

  KEY_REGEXP = /\A
    [a-f0-9]{8}-
    [a-f0-9]{4}-
    4[a-f0-9]{3}-
    [89aAbB][a-f0-9]{3}-
    [a-f0-9]{12}
    \Z/ix.freeze

  def self.key?(str)
    str.present? && str.match?(KEY_REGEXP)
  end

  def self.authenticate(key)
    key?(key) && find_by(key: key)&.issuer
  end

  def self.issue(user)
    create(key: SecureRandom.uuid, issued_at: Time.current, issuer: user)
  end
end
