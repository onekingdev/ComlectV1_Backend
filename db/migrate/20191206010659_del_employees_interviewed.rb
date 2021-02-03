# frozen_string_literal: true

class DelEmployeesInterviewed < ActiveRecord::Migration
  def change
    remove_column :annual_reports, :employees_interviewed
  end
end
