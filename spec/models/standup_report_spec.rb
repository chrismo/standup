# frozen_string_literal: true

require "rails_helper"

RSpec.describe StandupReport, type: :model do
  subject { StandupReport.new(date: Date.current, include_missing: false) }

  describe "week detail" do
    it "alphabetizes developers" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t")
      StandupItemFixture.create(developer: "bar", category: "a", task: "t")
      actual = subject.week_detail
      expected = [
        ["bar", [["a", ["t"]]]],
        ["foo", [["a", ["t"]]]],
      ]
      expect(actual).to eq expected
    end

    it "filters developers" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t")
      StandupItemFixture.create(developer: "bar", category: "a", task: "t")
      actual = StandupReport.new(date: Date.current, developer: "foo", include_missing: false).week_detail
      expected = [
        ["foo", [["a", ["t"]]]]
      ]
      expect(actual).to eq expected
    end

    it "sorts by category desc by count" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t1")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t1")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t2")
      actual = subject.week_detail
      expected = [
        ["foo", [
          ["b", ["t1", "t2"]],
          ["a", ["t1"]],
        ]],
      ]
      expect(actual).to eq expected
    end

    it "merges together same tasks and sorts by desc count" do
      StandupItemFixture.create(developer: "foo", category: "b", task: "t1")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t2")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t2")
      actual = subject.week_detail
      expected = [
        ["foo", [
          ["b", ["t2", "t1"]],
        ]],
      ]
      expect(actual).to eq expected
    end
  end

  describe "week detail including missing" do
    it "reports on missing data" do
      Timecop.freeze(Date.current.end_of_week) do
        StandupItemFixture.create(day: Date.current - 2, developer: "foo", category: "a", task: "t")
        actual = StandupReport.new(date: Date.yesterday).week_detail
        expected = [
          ["foo", [
            ["Missing", ["Mon", "Tue", "Wed", "Thu"]],
            ["a", ["t"]],
          ]]
        ]
        expect(actual).to eq expected
      end
    end

    it "does not report on missing data in the future" do
      Timecop.freeze(Date.current.beginning_of_week + 1) do
        StandupItemFixture.create(day: Date.current - 1, developer: "foo", category: "a", task: "t")
        StandupItemFixture.create(day: Date.current, developer: "foo", category: "a", task: "t")
        actual = StandupReport.new(date: Date.yesterday).week_detail
        expected = [
          ["foo", [
            ["a", ["t"]],
          ]]
        ]
        expect(actual).to eq expected
      end
    end

    it "filters developers from missing" do
      Timecop.freeze(Date.current.end_of_week) do
        StandupItemFixture.create(day: Date.current - 2, developer: "foo", category: "a", task: "t")
        StandupItemFixture.create(day: Date.current - 2, developer: "bar", category: "b", task: "q")
        actual = StandupReport.new(date: Date.yesterday, developer: "foo").week_detail
        expected = [
          ["foo", [
            ["Missing", ["Mon", "Tue", "Wed", "Thu"]],
            ["a", ["t"]],
          ]]
        ]
        expect(actual).to eq expected
      end
    end
  end

  describe "week summary" do
    it "alphabetizes developers" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t")
      StandupItemFixture.create(developer: "bar", category: "a", task: "t")
      week = subject.week_summary
      expected = {"bar" => ["a"], "foo" => ["a"], }
      expect(week.date).to eq Date.current.beginning_of_week
      expect(week.developers).to eq expected
    end

    it "sorts by category desc by count" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t1")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t1")
      StandupItemFixture.create(developer: "foo", category: "b", task: "t2")
      week = subject.week_summary
      expected = {"foo" => ["b", "a"]}
      expect(week.date).to eq Date.current.beginning_of_week
      expect(week.developers).to eq expected
    end

    it "filters on developer" do
      StandupItemFixture.create(developer: "foo", category: "a", task: "t")
      StandupItemFixture.create(developer: "bar", category: "a", task: "t")
      week = StandupReport.new(date: Date.current, developer: "foo", include_missing: false).week_summary
      expected = {"foo" => ["a"]}
      expect(week.date).to eq Date.current.beginning_of_week
      expect(week.developers).to eq expected
    end
  end

  describe "week summary include missing" do
    it "includes missing category" do
      # Today is Wednesday, Task entered for Monday, but nothing yet for Tuesday
      Timecop.freeze(Date.current.beginning_of_week + 2) do
        StandupItemFixture.create(day: Date.current - 2, developer: "foo", category: "a", task: "tt")
        week = StandupReport.new(date: Date.yesterday).week_summary
        expected = {"foo" => ["a", "Missing"]}
        expect(week.date).to eq Date.current.beginning_of_week
        expect(week.developers).to eq expected
      end
    end

    it "missing is not missing until the day after" do
      # Today is Tuesday, Task entered for Monday, but nothing yet for Tuesday
      Timecop.freeze(Date.current.beginning_of_week + 1) do
        StandupItemFixture.create(day: Date.current - 1, developer: "foo", category: "a", task: "tt")
        week = StandupReport.new(date: Date.yesterday).week_summary
        expected = {"foo" => ["a"]}
        expect(week.date).to eq Date.current.beginning_of_week
        expect(week.developers).to eq expected
      end
    end
  end

  describe "merge summaries" do
    it "merge all the things" do
      Timecop.freeze(Date.current.beginning_of_week + 1) do
        StandupItemFixture.create(day: Date.current - 1, developer: "foo", category: "a", task: "t1")
        StandupItemFixture.create(day: Date.current - 8, developer: "foo", category: "a", task: "t2")
        StandupItemFixture.create(day: Date.current - 1, developer: "bar", category: "b", task: "t1")
        StandupItemFixture.create(day: Date.current - 8, developer: "bar", category: "a", task: "t2")
        StandupItemFixture.create(day: Date.current - 1, developer: "qux", category: "c", task: "t1")
        w1 = StandupReport.new(include_missing: false, date: Date.current).week_summary
        w2 = StandupReport.new(include_missing: false, date: Date.current - 7).week_summary
        expect(StandupReport::Weeks.new([w1, w2]).developers).to eq ["bar", "foo", "qux"]

        # actual = StandupReport.new(date: Date.yesterday).merge_summaries([w1, w2])
        # expected = {
        #   'foo' => [['a'], ['a']],
        #   'bar' => [['b'], ['a']]
        # }
        # expect(actual).to eq expected
      end
    end
  end
end
