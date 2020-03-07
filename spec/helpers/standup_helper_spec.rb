# frozen_string_literal: true

require "rails_helper"

RSpec.describe StandupHelper, type: :helper do
  context "parse_day_content" do
    it "converts day of the week if today to today" do
      today = Date.current.strftime("%a")
      expect(parse_day_content(today)).to eq Date.current
    end

    it "converts full name day of the week if today to today" do
      today = Date.current.strftime("%A")
      expect(parse_day_content(today)).to eq Date.current
    end

    it "converts day of the week in the past if not today" do
      yesterday = (Date.current - 1).strftime("%a")
      expect(parse_day_content(yesterday)).to eq(Date.current - 1)
    end

    it "ignores prior day values" do
      last_week = (Date.current - 7).strftime("%a, %b %d %Y")
      expect(parse_day_content(last_week)).to eq(Date.current - 7)
    end

    it "translates y to yesterday" do
      expect(parse_day_content("y")).to eq(prior_workday)
    end

    it "translates y to prior work day" do
      Timecop.freeze(date_falls_on_a_monday) do
        expect(parse_day_content("y")).to eq(prior_workday)
      end
    end

    it "translates t to today" do
      expect(parse_day_content("t")).to eq(Date.current)
    end

    it "strips param content" do
      expect(parse_day_content(" t ")).to eq(Date.current)
    end
  end
end
