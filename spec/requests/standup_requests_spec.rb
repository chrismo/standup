# frozen_string_literal: true

require "rails_helper"

RSpec.describe "standup", type: :request do
  let(:user) { User.create(email: "foo@example.com") }

  before { login(user) }

  describe "standup" do
    it "should not blow up" do
      get "/standup"
    end
  end

  describe "standup for dev" do
    it "should not blow up" do
      get "/standup?dev=chrismo"
    end
  end

  describe "week detail" do
    it "should group by developer alphabetically" do
      get "/standup/week_detail"
    end
  end

  describe "week summary" do
    it "should not blow up" do
      get "/standup/week_summary"
    end
  end

  describe "writing items" do
    it "should create a new item" do
      item = {id: "", developer: "chrismo", day: "t", task: "t", category: "c"}
      expect { post "/standup", params: {items: [item]} }.to change { StandupItem.count }.by 1
    end

    it "should update an item" do
      item = StandupItemFixture.create(day: Date.current - 1)
      item_params = {id: item.id,
                     old_developer: item.developer, old_day: item.day.to_s,
                     old_task: item.task, old_category: item.category,
                     developer: "chrismo", day: "t", task: "t", category: "c"}
      expect { post "/standup", params: {items: [item_params]} }.to change { StandupItem.count }.by 0
      item = item.reload
      expect(item.developer).to eq "chrismo"
      expect(item.day).to eq Date.current
      expect(item.task).to eq "t"
      expect(item.category).to eq "c"
    end

    it "should delete an item" do
      item = StandupItemFixture.create
      form_params = {delete: item.id, items: [{id: "", developer: "", day: "", task: "", category: ""}]}
      expect { post "/standup", params: form_params }.to change { StandupItem.count }.by(-1)
      expect(StandupItem.find_by(id: item.id)).to be_nil
    end
  end

  describe "inline categories in square brackets at front of task" do
    it "should create a new category" do
      item = {id: "", developer: "chrismo", day: "t", task: "[c] t", category: ""}
      expect { post "/standup", params: {items: [item]} }.to change { StandupCategory.count }.by 1
      expect(StandupItem.last.task).to eq "t"
      expect(StandupItem.last.category).to eq "c"
    end

    it "should ignore square brackets not at the beginning" do
      item = {id: "", developer: "chrismo", day: "t", task: "t [c]", category: ""}
      expect { post "/standup", params: {items: [item]} }.to change { StandupCategory.count }.by 0
    end

    it "should update to an existing category" do
      StandupCategory.create!(category: "admin")
      item = {id: "", developer: "chrismo", day: "t", task: "[admin] t", category: ""}
      expect { post "/standup", params: {items: [item]} }.to change { StandupCategory.count }.by 0
      expect(StandupItem.last.task).to eq "t"
      expect(StandupItem.last.category).to eq "admin"
    end

    it "should remove any unused categories to clean up typos" do
      item_params = {id: "", developer: "chrismo", day: "t", task: "[typo] t", category: ""}
      expect { post "/standup", params: {items: [item_params]} }.to change { StandupCategory.count }.by 1
      item = StandupItem.last
      expect(item.task).to eq "t"
      expect(item.category).to eq "typo"

      item_params = {id: item.id,
                     old_developer: item.developer, old_day: item.day.to_s,
                     old_task: item.task, old_category: item.category,
                     developer: "chrismo", day: "t", task: "[admin] t", category: "typo"}
      expect { post "/standup", params: {items: [item_params]} }.to change { StandupCategory.count }.by 0
      item = StandupItem.last
      expect(item.task).to eq "t"
      expect(item.category).to eq "admin"

      expect(StandupCategory.find_by(category: "typo")).to be_nil
    end
  end
end
