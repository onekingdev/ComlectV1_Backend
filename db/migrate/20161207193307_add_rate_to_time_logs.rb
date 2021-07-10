# frozen_string_literal: true

class AddRateToTimeLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :time_logs, :hourly_rate, :decimal
    add_column :time_logs, :total_amount, :decimal
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE time_logs SET hourly_rate = (
            SELECT hourly_rate FROM projects
            INNER JOIN timesheets ON timesheets.project_id = projects.id AND timesheets.id = time_logs.timesheet_id
          );
          UPDATE time_logs SET total_amount = hourly_rate * hours;
        SQL
      end
    end
  end
end
