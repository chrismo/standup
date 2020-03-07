# frozen_string_literal: true

class BaseFixture
  def self.build(params = {})
    self.new(params)
  end

  def self.create(params = {})
    self.new(params).tap(&:save!)
  end

  def self.opts
    @opts ||= {}
  end

  def self.merge_opts(defaults, opts)
    defaults.merge(self.opts).merge(opts).tap do
      # reset these to prevent accidental reuse on future fixtures
      @opts = nil
    end
  end
end

class StandupItemFixture < BaseFixture
  def self.new(opts = {})
    defaults = {
      developer: "bot",
      day: Date.current,
      task: "task",
      category: "category"
    }
    StandupItem.new(merge_opts(defaults, opts))
  end
end

def date_falls_on_a_monday
  Date.parse("2019-04-22")
end
