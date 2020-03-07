# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :if_not_signed_in_redirect
  before_action :ensure_email, only: [:create]

  def index; end

  def create
    if (user = User.find_or_create_by(email: email))
      reset_session
      session[:user_id] = user.id
    end
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def ensure_email
    render plain: "Login failed.", status: :internal_server_error unless email
  end

  def email
    request.env["omniauth.auth"]["extra"]["id_info"]["email"]
  end
end
