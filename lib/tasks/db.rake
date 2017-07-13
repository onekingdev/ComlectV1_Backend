# frozen_string_literal: true

namespace :db do
  task cleanup: :environment do
    if ENV['FORCE'] != '1'
      puts 'Usage: FORCE=1 rake db:cleanup'
      exit 1
    end

    tables = %w[
      admin_users
      answers
      bank_accounts
      businesses
      businesses_industries
      businesses_jurisdictions
      charges
      documents
      education_histories
      email_threads
      favorites
      flags
      industries
      industries_projects
      industries_specialists
      job_applications
      jurisdictions
      jurisdictions_projects
      jurisdictions_specialists
      messages
      notifications
      payment_profiles
      payment_sources
      project_ends
      project_extensions
      project_invites
      project_issues
      projects
      projects_skills
      questions
      ratings
      settings
      skills
      skills_specialists
      stripe_accounts
      specialists
      time_logs
      timesheets
      transactions
      users
      work_experiences
    ]

    tables.each do |table|
      ActiveRecord::Base.connection.execute "DELETE FROM #{table}"
      begin
        ActiveRecord::Base.connection.execute "ALTER SEQUENCE #{table}_id_seq RESTART WITH 1"
      rescue ActiveRecord::StatementInvalid # Join tables without primary ID column
        next
      end
    end
  end
end
