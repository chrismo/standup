# frozen_string_literal: true

# rubocop:disable Rails/HttpPositionalArguments
module ApiHelpers
  # Could we override this somehow?
  def api_user
    @api_user ||= User.create(email: "default_api_user@example.com")
  end

  # Could we override this somehow?
  def api_key
    @api_key ||= ApiKey.issue(api_user)
  end

  def api_get(path, opts = {})
    get(path, merge_api_key(opts))
  end

  def api_post(path, opts = {})
    post(path, merge_api_key(opts))
  end

  private

  def merge_api_key(opts = {})
    opts[:params] ||= {}
    opts[:params][:api_key] = api_key.key
    opts
  end
end
# rubocop:enable Rails/HttpPositionalArguments
