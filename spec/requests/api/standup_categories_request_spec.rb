# frozen_string_literal: true

require "rails_helper"

RSpec.describe "api/standup_categories", type: :request do
  before do
    %w[foo bar baz].each do |category|
      StandupCategory.create(category: category)
    end
  end

  describe "index" do
    it "succeeds without params" do
      api_get "/api/standup_categories"

      expect(response).to be_successful
      expect(response.body).to eq({ categories: %w[bar baz foo]}.to_json)
    end
  end
end
