# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it "extracts name from email as default" do
    u = User.create(email: "foo@mysteryscience.com")
    expect(u.reload.name).to eq "foo"
  end

  it "stores name preference" do
    u = User.create(email: "foo@mysteryscience.com")
    u.settings = {"name" => "bar"}
    expect(u.name).to eq "bar"
  end
end
