# frozen_string_literal: true

require "rails_helper"

RSpec.describe StandupView do
  describe "today standup" do
    it "includes any today entries if today is Monday" do
      # 5/27/2019 is a Monday
      Timecop.travel(Date.parse("2019-05-27")) do
        create_fixtures
        v = StandupView.new(date: Date.current, developer: "bot")
        days = v.today_standup.keys
        expect(days).to eq(to_dates([20, 21, 22, 23, 24, 26, 27]))
      end
    end

    it "includes the last 7 days of entries if today is in the current week" do
      # 5/28/2019 is a Tuesday
      Timecop.travel(Date.parse("2019-05-28")) do
        create_fixtures
        v = StandupView.new(date: Date.current, developer: "bot")
        days = v.today_standup.keys
        expect(days).to eq(to_dates([21, 22, 23, 24, 27, 28]))
      end
    end

    it "includes all days of the week when it is a past week" do
      # 5/28/2019 is a Tuesday
      Timecop.travel(Date.parse("2019-05-28")) do
        create_fixtures
        v = StandupView.new(date: Date.current - 7, developer: "bot")
        days = v.today_standup.keys
        expect(days).to eq(to_dates((20..24)))
      end
    end

    it "includes missing days" do
      # 5/30/2019 is a Thursday
      Timecop.travel(Date.parse("2019-05-30")) do
        create_fixtures
        v = StandupView.new(date: Date.current, developer: "bot")
        days = v.today_standup.keys

        expect(days).to eq(to_dates([23, 24, 27, 28, 29, 30]))
        expect_missing(v.today_standup, to_dates([23, 24, 27, 28]))
      end
    end

    it "does not include today as a missing day" do
      Timecop.travel(Date.parse("2019-05-30")) do
        create_fixtures([1, 2, 3, 6, 7])
        v = StandupView.new(date: Date.current, developer: "bot")
        days = v.today_standup.keys

        expect(days).to eq(to_dates([23, 24, 27, 28, 29]))
        expect_missing(v.today_standup, to_dates([]))
      end
    end
  end
end

def create_fixtures(days_ago = [0, 1, 8])
  days_ago.each { |d| StandupItemFixture.create(day: d.days.ago) }
end

def to_dates(days_of_month)
  days_of_month.map { |i| Date.parse("2019-05-#{i}") }
end

def expect_missing(standup, missing_dates)
  standup.each do |date, items|
    if missing_dates.include?(date)
      expect(items).to be_empty, "expected #{date} to be a missing day"
    else
      expect(items).not_to be_empty, "expected #{date} to NOT be a missing day"
    end
  end
end
