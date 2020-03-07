# frozen_string_literal: true

require "rails_helper"

RSpec.describe "settings", type: :request do
  let(:user) { User.create(email: "foo@example.com") }

  before { login(user) }

  it "should update settings" do
    post "/settings", params: {settings: [{name: "bar"}]}

    expect(user.reload.settings["name"]).to eq "bar"
  end
end
