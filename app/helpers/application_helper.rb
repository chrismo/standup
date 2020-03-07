# frozen_string_literal: true

module ApplicationHelper
  def env_title(title)
    "#{title}#{Rails.env.development? ? ' [DEV]' : ''}"
  end
end
