# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiKey, type: :model do
  describe "issue" do
    let(:user) { User.create(email: "foo@example.com") }

    it "returns an api key" do
      freeze_time do
        api_key = ApiKey.issue(user)
        expect(api_key.issuer).to eq(user)
        expect(api_key.issued_at).to eq(Time.current)
        expect(ApiKey.key?(api_key.key)).to eq(true)
      end
    end
  end

  describe "authenticate" do
    let(:user) { User.create(email: "foo@example.com") }
    let(:api_key) { ApiKey.issue(user) }

    it "returns user is api key is correct" do
      expect(ApiKey.authenticate(api_key.key)).to eq(user)
    end

    it "returns nil when the api key is not correct" do
      expect(ApiKey.authenticate(SecureRandom.uuid)).not_to eq(user)
    end
  end
end
