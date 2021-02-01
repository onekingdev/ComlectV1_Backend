# frozen_string_literal: true

class RemoveFindingsFromAnnualReport < ActiveRecord::Migration[6.0]
  def change
    remove_column :annual_reports, :findings
  end
end
