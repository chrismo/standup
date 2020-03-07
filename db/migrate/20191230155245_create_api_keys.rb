# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string   :key,       null: false
      t.datetime :issued_at, null: false
      t.integer  :issuer_id, null: false

      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end
end
