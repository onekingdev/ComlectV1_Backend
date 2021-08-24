class AddAssigneeToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :assignee_type, :string, default: nil
    add_column :reminders, :assignee_id, :integer, default: nil
  end
end
