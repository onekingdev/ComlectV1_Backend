# frozen_string_literal: true

class AddOnboardingPassedToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :onboarding_passed, :boolean, default: false
  end
end
