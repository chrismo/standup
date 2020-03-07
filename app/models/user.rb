# frozen_string_literal: true

class User < ApplicationRecord
  has_many :api_keys, foreign_key: "issuer_id", inverse_of: "issuer"
end
