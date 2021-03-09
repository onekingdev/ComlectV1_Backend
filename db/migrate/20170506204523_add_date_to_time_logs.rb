# frozen_string_literal: true

class AddDateToTimeLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :time_logs, :date, :date, default: nil
  end
end
