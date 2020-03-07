# frozen_string_literal: true

module Db
  class PostgresDumpAndRestore
    attr_reader :source_database, :destination_database

    def initialize
      @source_database = to_uri(ActiveRecord::Base.configurations["production"])
      @destination_database = ActiveRecord::Base.configurations["development"]["database"]
    end

    def to_uri(config)
      "postgres://#{config['username']}:#{config['password']}@#{config['host']}:#{config['port']}/#{config['database']}"
    end

    def dump_data
      dump_from_source(%w[-T ar_internal_metadata])
    end

    def restore_data
      restore_source_dump_to_destination
    end

    private

    def dump_from_source(extra_args = [])
      cmd = [
        "time pg_dump #{source_database}",
        "--format c --no-acl --no-owner",
        extra_args.join(" "),
        "> #{source_database_dump_path}"
      ]
      execute_command(cmd.join(" "))
    end

    def restore_source_dump_to_destination(extra_args = [])
      cmd = [
        "time pg_restore -d #{destination_database}",
        "--verbose --clean --jobs 4 --no-acl --no-owner",
        extra_args.join(" "),
        source_database_dump_path,
        "&> #{restore_log}"
      ]
      execute_command(cmd.join(" "))
    end

    def restore_log
      Rails.root.join("tmp", "pg_restore.log")
    end

    def source_database_dump_path
      Rails.root.join("tmp", "pg_dump.dump")
    end

    def execute_command(cmd)
      puts cmd
      puts `#{cmd}`
    end
  end
end
