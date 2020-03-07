# frozen_string_literal: true

class CreateStandupItems < ActiveRecord::Migration[5.2]
  def change
    create_table :standup_items do |t|
      t.string :developer
      t.date :day
      t.string :category
      t.string :task

      t.timestamps
    end
  end
end
