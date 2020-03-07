# frozen_string_literal: true

# `StandupView` is primarily about `today_standup`. Over time, it's also
# fronting data from the `StandupReport`. Which makes it a little confusing as
# to the responsibility division between the two classes.
class StandupView
  include Workdays

  attr_reader :date, :developer
  attr_reader :items, :categories
  attr_reader :today_standup
  attr_reader :week_summary, :week_detail

  def initialize(date:, developer:)
    @date = date
    @developer = developer

    load_items
    load_categories
    load_today_standup
    load_summary
    load_detail
  end

  private

  def load_detail
    @week_detail = StandupReport.new(date: @date, developer: @developer).week_detail
  end

  def load_summary
    @week_summary = StandupReport::Weeks.new([StandupReport.new(date: @date).week_summary])
  end

  def daily_standup_start_date
    if (Date.current - @date) < 7
      Date.current - 7
    else
      beg_day
    end
  end

  def daily_standup_end_date
    if (Date.current - @date) < 7
      Date.current
    else
      end_day
    end
  end

  def load_today_standup
    @today_standup = begin
      items = StandupItem.order(day: :asc, developer: :asc, category: :asc, task: :asc).
        where(developer: @developer).
        where("day between ? and ?", *today_date_range).to_a
      missing_items = StandupReport::Missing.missing_dev_days(*missing_date_range)
      missing_items.select! { |i| i.developer == @developer && weekday?(i.day) }

      # Add missing items, then group by day, so missing day groups will be
      # created...
      all_items = (items + missing_items).group_by(&:day).sort.to_h

      # ... now delete the actual items with category Missing, so that missing
      # days won't have any items in them at all.
      all_items.each { |_, v| v.delete_if { |i| i.category == "Missing" } }
    end
  end

  def today_date_range
    [daily_standup_start_date, daily_standup_end_date]
  end

  def missing_date_range
    end_date = daily_standup_end_date
    end_date -= 1 if end_date == Date.current
    [daily_standup_start_date, end_date]
  end

  def load_categories
    @categories = [StandupCategory.new] + StandupCategory.all.order(:category)
  end

  def load_items
    @items = StandupItem.order(day: :desc, developer: :asc, category: :asc, task: :asc)
    @items = @items.where(developer: @developer) if @developer.present?
    @items = @items.where("day between ? and ?", daily_standup_start_date, end_day_including_current)
  end
end
