# frozen_string_literal: true

require "chronic"

class StandupController < ApplicationController
  include StandupHelper

  before_action :filter_by_date
  before_action :filter_by_dev

  def index
    @standup_view = StandupView.new(date: @date, developer: @dev)
  end

  def mass_update
    StandupBulkUpdater.create_all!(new_item_params)
    StandupBulkUpdater.update_all!(changed_item_params)
    StandupBulkUpdater.delete_all!(delete_item_params)
    StandupBulkUpdater.cleanup_unused_categories!

    redirect_to action: "index", dev: @dev, date: @date
  end

  def week_detail
    standup_view = StandupView.new(date: @date, developer: @dev)
    @week_detail = standup_view.week_detail
    @week_summary = standup_view.week_summary
  end

  # I don't like this name, and the view names are redundant.
  def week_summaries
    @number_of_weeks = 11
    weeks = (0..@number_of_weeks).to_a.map do |week|
      start_date = (@date - (7 * week)).beginning_of_week
      StandupReport.new(date: start_date).week_summary
    end
    @week_summaries = StandupReport::Weeks.new(weeks)
  end

  def planning
    @number_of_weeks = 11
    weeks = ((-@number_of_weeks + 2)..1).to_a.reverse.map do |week|
      start_date = (@date - (7 * week)).beginning_of_week
      StandupReport.new(date: start_date).week_summary
    end
    @week_summaries = StandupReport::Weeks.new(weeks)
  end

  private

  def filter_by_dev
    @dev = standup_params[:dev] || current_user.name
  end

  def filter_by_date
    @date ||= begin
      date = if standup_params[:date]
               Date.parse(standup_params[:date])
             else
               Date.current
             end
      date.beginning_of_week
    end
  end

  def standup_params
    old_data_fields = data_fields.map { |sym| "old_#{sym}".to_sym }
    params.permit(:dev, :date, :new_rows, :page, :delete, items: [:id] + data_fields + old_data_fields)
  end

  def new_item_params
    standup_params[:items].
      select { |item_fields| item_fields[:id].blank? }
  end

  def changed_item_params
    standup_params[:items].
      select { |fields| fields[:id].present? }.
      select { |fields| data_params(fields).values.all?(&:present?) }.
      select { |fields| data_fields.any? { |field_name| fields["old_#{field_name}"] != fields[field_name] } }
  end

  def delete_item_params
    standup_params[:delete].present? ? [{id: standup_params[:delete]}] : []
  end

  def data_fields
    StandupBulkUpdater.data_fields
  end

  def data_params(item_params)
    item_params.slice(*data_fields).
      tap { |fields| fields[:day] = parse_day_content(fields[:day]) }
  end
end
