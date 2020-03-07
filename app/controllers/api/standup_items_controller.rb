# frozen_string_literal: true

module Api
  class StandupItemsController < ApplicationController
    skip_forgery_protection

    before_action :validate_params, only: [:create]

    def index
      render json: StandupItem.order("day desc, created_at desc").
        where("day > ?", 10.days.ago)
    end

    def create
      render json: StandupItem.create(standup_item_params)
    end

    private

    def validate_params
      errors = []
      errors << "Missing developer" if developer.blank?
      errors << "Missing day" if day.blank?
      errors << "Missing category" if category.blank?
      errors << "Missing task" if task.blank?

      render json: { errors: errors }, status: :internal_server_error if errors.any?
    end

    def developer
      standup_item_params[:developer]
    end

    def day
      Date.parse(standup_item_params[:day])
    rescue StandardError
      nil
    end

    def category
      StandupCategory.find_by(category: standup_item_params[:category])
    end

    def task
      standup_item_params[:task]
    end

    def standup_item_params
      params.permit(:developer, :day, :category, :task)
    end
  end
end
