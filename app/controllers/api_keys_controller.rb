# frozen_string_literal: true

class ApiKeysController < ApplicationController
  before_action :ensure_api_key, only: [:destroy]

  helper_method :api_key
  helper_method :api_keys

  def index; end

  def create
    api_key = ApiKey.issue(current_user)
    redirect_to api_keys_url, alert: "Created key: #{api_key.key}"
  end

  def destroy
    api_key.destroy

    redirect_to api_keys_url, alert: "Key revoked"
  end

  protected

  def ensure_api_key
    render plain: "Unknown api key.", status: :internal_server_error unless api_key
  end

  def api_key
    @api_key ||= ApiKey.find_by(id: params[:id])
  end

  def api_keys
    # TODO: Will we ever need paging?
    @api_keys ||= ApiKey.order("issued_at desc").all
  end
end
