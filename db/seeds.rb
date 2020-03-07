# frozen_string_literal: true

require_relative "../lib/db/postgres_dump_and_restore"

Db::PostgresDumpAndRestore.new.tap do |pg|
  pg.dump_data
  pg.restore_data
end
