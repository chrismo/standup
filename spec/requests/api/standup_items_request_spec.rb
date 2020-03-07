# frozen_string_literal: true

require "rails_helper"

RSpec.describe "api/standup_items", type: :request do
  before do
    StandupCategory.create(category: "Various")
  end

  describe "create" do
    it "should succeed" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "2019-12-16",
        category: "Various",
        task: "test standup items api"
      }

      expect(response).to be_successful
      expect(response.body).to eq(StandupItem.last.to_json)
    end

    it "fails if developer missing" do
      api_post "/api/standup_items", params: {
        day: "2019-12-16",
        category: "Various",
        task: "test standup items api"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing developer"] }.to_json)
    end

    it "fails if day missing" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        category: "Various",
        task: "test standup items api"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing day"] }.to_json)
    end

    it "fails if day invalid" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "foo",
        category: "Various",
        task: "test standup items api"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing day"] }.to_json)
    end

    it "fails if category missing" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "2019-12-16",
        task: "test standup items api"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing category"] }.to_json)
    end

    it "fails if category invalid" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "2019-12-16",
        category: "Foo",
        task: "test standup items api"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing category"] }.to_json)
    end

    it "fails if task missing" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "2019-12-16",
        category: "Various"
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing task"] }.to_json)
    end

    it "fails if task missing" do
      api_post "/api/standup_items", params: {
        developer: "eki",
        day: "2019-12-16",
        category: "Various",
        task: ""
      }

      expect(response).to be_server_error
      expect(response.body).to eq({ errors: ["Missing task"] }.to_json)
    end
  end

  describe "index" do
    it "succeeds without params" do
      api_get "/api/standup_items"

      expect(response).to be_successful
    end
  end
end
