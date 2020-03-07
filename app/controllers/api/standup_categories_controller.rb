# frozen_string_literal: true

module Api
  class StandupCategoriesController < ApplicationController
    skip_forgery_protection

    def index
      render json: { categories:
        StandupCategory.order(:category).pluck(:category) }
    end
  end
end
