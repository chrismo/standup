# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :signed_in?

  before_action :if_not_signed_in_redirect

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= ApiKey.authenticate(params[:api_key]) ||
                      User.find_by(id: session[:user_id])
  end

  def if_not_signed_in_redirect
    unless signed_in?
      flash[:error] = "You will need to authenticate to do that!"
      redirect_to login_url
    end
  end
end
