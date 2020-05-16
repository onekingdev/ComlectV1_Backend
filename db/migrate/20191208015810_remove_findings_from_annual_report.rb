# frozen_string_literal: true

class RemoveFindingsFromAnnualReport < ActiveRecord::Migration
  def change
    remove_column :annual_reports, :findings
  end
end
