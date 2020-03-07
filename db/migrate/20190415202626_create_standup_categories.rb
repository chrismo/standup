# frozen_string_literal: true

class CreateStandupCategories < ActiveRecord::Migration[5.2]
  def down
    drop_table :standup_categories
  end

  def up # rubocop:disable all
    create_table :standup_categories do |t|
      t.string :category
    end
    add_index :standup_categories, :category, unique: true
  end
end
