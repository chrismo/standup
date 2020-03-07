# frozen_string_literal: true

module Workdays
  def weekday?(day)
    day.wday >= 1 && day.wday <= 5
  end

  def prior_workday
    (1..3).map { |i| Date.current - i }.detect(&method(:weekday?))
  end

  def beg_day
    @date.beginning_of_week
  end

  def end_day
    @date.end_of_week
  end

  # Mondays for the current week are special. We want to still be focused on
  # last week, but also include today in some views.
  def end_day_including_current
    end_day == Date.current.yesterday ? Date.current : end_day
  end

  def parse_day_content(date_text)
    # If today is 'Tue', then:
    #   Chronic.parse('Tue')                 => next week tuesday
    #   Chronic.parse('Tue', context: :past) => last week tuesday
    #
    # No simple way to get today if the day of the week matches. I guess the
    # thinking from Chronic is that if you wanted today you would have said
    # 'Today'.
    #
    # Since our app defaults to using 'Mon', 'Tue' in the UI, we need to
    # intercede.
    #
    # This also provides two convenience strings, 't' and 'y' for Today and
    # Yesterday.

    return date_text if date_text.blank?

    date_text = date_text.strip
    if text_is_only_day_of_week?(date_text)
      Date.current
    elsif date_text == "t"
      Date.current
    elsif date_text == "y"
      prior_workday
    else
      parse_day_content_with_chronic(date_text)
    end
  end

  def text_is_only_day_of_week?(day_of_week)
    /\A#{Date.current.strftime("%a")}\z/i.match?(day_of_week) ||
      /\A#{Date.current.strftime("%A")}\z/i.match?(day_of_week)
  end

  def parse_day_content_with_chronic(date_text)
    parsed_date = Chronic.parse(date_text)
    return nil if parsed_date.nil?

    result = parsed_date.to_date
    result = Chronic.parse(date_text, context: :past).to_date if result > Date.current
    result
  end
end
