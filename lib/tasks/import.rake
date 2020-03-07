# frozen_string_literal: true

task import: :environment do
  PullRequestImporter.new.import
end
