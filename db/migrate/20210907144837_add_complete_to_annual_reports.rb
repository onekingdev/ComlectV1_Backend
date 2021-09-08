class AddCompleteToAnnualReports < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reports, :complete, :boolean, default: false
  end
end
