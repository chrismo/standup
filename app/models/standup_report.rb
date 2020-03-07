# frozen_string_literal: true

class StandupReport
  include Workdays

  class Week
    attr_reader :date, :developers

    def initialize(date)
      @date = date
      @developers = {}
    end

    def add_dev_categories(developer, categories)
      @developers[developer] = categories
    end
  end

  # I don't like this name.
  class Weeks
    attr_reader :weeks

    def initialize(weeks)
      @weeks = weeks
    end

    def developers
      @weeks.map(&:developers).map(&:keys).flatten.uniq.sort
    end
  end

  def initialize(date:, developer: nil, include_missing: true)
    @date = date
    @developer = developer
    @include_missing = include_missing
  end

  def week_detail
    week_ungrouped_items.group_by(&:developer).sort.
      map do |dev, dev_items|
      [
        dev,
        group_and_sort_by_desc_count(dev_items, :category).map do |cat, cat_items|
          [
            cat,
            group_and_sort_by_desc_count(cat_items, :task).map { |task, _| task }
          ]
        end
      ]
    end
  end

  def week_summary
    Week.new(beg_day).tap do |week|
      week_detail.map do |dev, dev_cats|
        week.add_dev_categories(dev, dev_cats.map(&:first))
      end
    end
  end

  private

  def week_ungrouped_items
    items = StandupItem.where("day between ? and ?", beg_day, end_day)
    items = items.where(developer: @developer) if @developer.present?
    items = items.to_a
    developer_criteria = @developer.presence || "%"
    items += Missing.missing_dev_days(beg_day, last_week_day_not_in_future, developer_criteria).to_a if @include_missing
    items
  end

  def last_week_day_not_in_future
    friday = end_day - 2
    [friday, Date.yesterday].min
  end

  def group_and_sort_by_desc_count(ary, group_by)
    ary.group_by(&group_by).map do |thing, thing_items|
      [thing,
       thing_items]
    end.sort_by do |_thing, thing_items|
      -thing_items.length
    end
  end

  module Missing
    # rubocop:disable Metrics/MethodLength
    def self.missing_dev_days(begin_date, end_date, developer = "%")
      sql = <<~_
        with all_dev_days as (select *
                              from (select distinct developer
                                    from standup_items
                                    where day between '#{begin_date}' and '#{end_date}'
                                      and developer like '#{developer}')
                                       as developers
                                       cross join
                                   (select ((generate_series('#{begin_date}', '#{end_date}', '1 day'::interval))::date) as day)
                                       as workdays
                              order by developer, day),

             entered_dev_days as (select distinct developer, day
                                  from standup_items
                                  where day between '#{begin_date}' and '#{end_date}')

             select add.developer,
                    add.day,
                    'Missing'              as category,
                    to_char(add.day, 'Dy') as task
             from all_dev_days as add
                      left join entered_dev_days on
                     add.developer = entered_dev_days.developer and
                     add.day = entered_dev_days.day
             where entered_dev_days.developer is null
      _
      StandupItem.find_by_sql(sql)
    end
    # rubocop:enable Metrics/MethodLength
  end
end
