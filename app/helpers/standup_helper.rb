# frozen_string_literal: true

module StandupHelper
  include Workdays

  def new_standup_row_count
    return params[:new_rows].to_i if params[:new_rows].to_i.positive?

    1
  end
end
