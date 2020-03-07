# frozen_string_literal: true

class StandupBulkUpdater
  class << self
    include Workdays

    def data_fields
      %i[developer day task category]
    end

    def expand_date_ranges(params)
      params.map do |attributes|
        day = attributes[:day]
        date_range = parse_date_range(day)
        if date_range
          date_range.map do |date|
            attributes.dup.tap { |h| h[:day] = date.to_s }
          end
        else
          attributes
        end
      end.flatten
    end

    def parse_date_range(day)
      # Chronic can parse a single date with hyphen separators, so give it precedence
      hyphened_range = (day.count("-") == 1) && Chronic.parse(day).nil?
      if hyphened_range
        dates = day.split(/-/).
          map(&method(:parse_day_content)).
          compact.
          map(&:to_date)
        (dates.first..dates.last).to_a.select(&:on_weekday?)
      elsif /;/.match?(day)
        day.split(/;/).
          map(&method(:parse_day_content)).
          compact.
          map(&:to_date)
      end
    end

    def create_all!(params)
      expand_date_ranges(params).each do |attributes|
        attributes = data_params(attributes)

        next unless attributes.slice(:developer, :day, :task, :category).values.all?(&:present?)

        StandupItem.create!(attributes)
      end
    end

    def update_all!(params)
      params.each do |attributes|
        update_params = data_params(attributes)
        StandupItem.find(attributes[:id]).update!(update_params)
      end
    end

    def delete_all!(params)
      params.each do |attributes|
        StandupItem.find(attributes[:id]).destroy!
      end
    end

    def parse_inline_category(fields)
      regex = /\A\[(.*?)\](.*)\z/
      if fields[:task]&.match?(regex)
        new_category, new_task = fields[:task].scan(regex).flatten
        StandupCategory.find_or_create_by!(category: new_category)
        fields[:category] = new_category.strip
        fields[:task] = new_task.strip
      end
    end

    def data_params(params)
      params.slice(*data_fields).
        tap do |fields|
        fields[:day] = parse_day_content(fields[:day])
        parse_inline_category(fields)
      end
    end

    def cleanup_unused_categories!
      sql = <<~_
        select c.*
        from standup_categories c left join standup_items i on c.category = i.category
        where i.id is null
      _
      StandupCategory.find_by_sql(sql).each(&:destroy!)
    end
  end
end
