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

    StandupCategory.create(category: 'Actions')
    StandupCategory.create(category: 'Actions BigInt ID')
    StandupCategory.create(category: 'Actions Re-architecture')
    StandupCategory.create(category: 'Activity Prep')
    StandupCategory.create(category: 'Administrivia')
    StandupCategory.create(category: 'District Dupes')
    StandupCategory.create(category: 'Email Support')
    StandupCategory.create(category: 'Email Support (Endorsements)')
    StandupCategory.create(category: 'Goals')
    StandupCategory.create(category: 'Incident')
    StandupCategory.create(category: 'Infrastructure')
    StandupCategory.create(category: 'Management')
    StandupCategory.create(category: 'Meetings')
    StandupCategory.create(category: 'Membership')
    StandupCategory.create(category: 'Offsite')
    StandupCategory.create(category: 'Rails Upgrade')
    StandupCategory.create(category: 'RailsConf')
    StandupCategory.create(category: 'Recruiting')
    StandupCategory.create(category: 'Reflections')
    StandupCategory.create(category: 'Roles')
    StandupCategory.create(category: 'Sales')
    StandupCategory.create(category: 'Sales Email Autonomy')
    StandupCategory.create(category: 'Sales Support')
    StandupCategory.create(category: 'Scopes')
    StandupCategory.create(category: 'Search')
    StandupCategory.create(category: 'Segments')
    StandupCategory.create(category: 'Self Serve District Quotes')
    StandupCategory.create(category: 'Simplified Activity Prep')
    StandupCategory.create(category: 'Slideshow')
    StandupCategory.create(category: 'Slideshow (Tablet)')
    StandupCategory.create(category: 'Slideshow Metrics')
    StandupCategory.create(category: 'Slideshow Metrics (Durations)')
    StandupCategory.create(category: 'Slideshow Unification')
    StandupCategory.create(category: 'Slideshow Unification (CMS)')
    StandupCategory.create(category: 'Slideshow Unification (Model)')
    StandupCategory.create(category: 'Slideshow Unification (Video)')
    StandupCategory.create(category: 'Slideshow Various')
    StandupCategory.create(category: 'Supplies Next Rev')
    StandupCategory.create(category: 'Supply Pack Orders')
    StandupCategory.create(category: 'Time Off')
    StandupCategory.create(category: 'Time Off (Sick)')
    StandupCategory.create(category: 'Unify User Accounts')
    StandupCategory.create(category: 'Usage Dashboards')
    StandupCategory.create(category: 'Various')
  end
end
