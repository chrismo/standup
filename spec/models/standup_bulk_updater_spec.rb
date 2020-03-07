# frozen_string_literal: true

require "rails_helper"

RSpec.describe StandupBulkUpdater do
  def string_fields
    StandupBulkUpdater.data_fields.map(&:to_s)
  end

  context "create" do
    # sort of an integration-y test verifying a few different things
    it "creates new records with special day parsing" do
      input_a = {developer: "bar", day: "today", task: "t", category: "c"}
      input_b = {developer: "foo", day: "y", task: "t", category: "c"}
      StandupBulkUpdater.create_all!([input_a, input_b])

      actual_a = StandupItem.last(2).first.attributes.slice(*string_fields)
      input_a[:day] = Date.current
      expect(actual_a).to eq input_a.stringify_keys

      actual_b = StandupItem.last.attributes.slice(*string_fields)
      input_b[:day] = StandupBulkUpdater.prior_workday
      expect(actual_b).to eq input_b.stringify_keys
    end

    it "skips new record with missing fields" do
      input_params = {developer: "bar", day: "", task: "t", category: "c"}
      expect { StandupBulkUpdater.create_all!([input_params]) }.to change { StandupItem.count }.by(0)
    end

    it "skips new record with invalid date" do
      input_params = {developer: "bar", day: "garbage", task: "t", category: "c"}
      expect { StandupBulkUpdater.create_all!([input_params]) }.to change { StandupItem.count }.by(0)
    end
  end

  context "update" do
    it "updates records" do
      item_a = StandupItemFixture.create(developer: "foo")
      item_b = StandupItemFixture.create(developer: "bar")
      input_a = item_a.attributes
      input_a["developer"] = "qux"
      input_a["day"] = input_a["day"].to_s
      input_a.symbolize_keys!

      input_b = item_b.attributes
      input_b["developer"] = "qux"
      input_b["day"] = input_b["day"].to_s
      input_b.symbolize_keys!
      StandupBulkUpdater.update_all!([input_a, input_b])

      expect(StandupItem.last(2).map(&:developer)).to eq ["qux", "qux"]
    end
  end

  context "delete" do
    it "deletes records" do
      item_a = StandupItemFixture.create(developer: "foo")
      item_b = StandupItemFixture.create(developer: "bar")

      expect do
        StandupBulkUpdater.delete_all!([{id: item_a.id}, {id: item_b.id}])
      end.to change { StandupItem.count }.by(-2)
    end
  end

  context "date range" do
    it "accepts hyphenated today and tomorrow" do
      Timecop.freeze(date_falls_on_a_monday) do
        input_a = {developer: "bar", day: "today-tomorrow", task: "t", category: "c"}
        expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(2)
      end
    end

    it "skips weekends" do
      Timecop.freeze(date_falls_on_a_monday) do
        input_a = {developer: "bar", day: "today-next week tuesday", task: "t", category: "c"}
        expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(7)
      end
    end

    it "requires there only be one hyphen" do
      Timecop.freeze(date_falls_on_a_monday) do
        input_a = {developer: "bar", day: "today-next week tuesday-next year", task: "t", category: "c"}
        expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(0)
      end
    end

    context "day of week ranges" do
      it "will not work with if first day is today" do
        # This evaluates to "Today..Last Wednesday" - which is a 0 item range.
        Timecop.freeze(date_falls_on_a_monday) do
          input_a = {developer: "bar", day: "Mon-Wed", task: "t", category: "c"}
          expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(0)
        end
      end

      it "will work with if first day is not today" do
        # These will be created in the prior week, like all of the items.
        Timecop.freeze(date_falls_on_a_monday) do
          input_a = {developer: "bar", day: "Tue-Thu", task: "t", category: "c"}
          expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(3)
        end
      end
    end

    it "handles a list of individual dates separated by semi-colon" do
      Timecop.freeze(date_falls_on_a_monday) do
        input_a = {developer: "bar", day: "today;7-1-2019", task: "t", category: "c"}
        expect { StandupBulkUpdater.create_all!([input_a]) }.to change { StandupItem.count }.by(2)
      end
    end
  end
end
