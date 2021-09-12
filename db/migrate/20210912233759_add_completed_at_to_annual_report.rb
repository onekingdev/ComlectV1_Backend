class AddCompletedAtToAnnualReport < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reports, :completed_at, :datetime, default: nil
  end
end
