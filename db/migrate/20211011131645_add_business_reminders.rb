class AddBusinessReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :business_id, :integer, index: true, default: nil
  end
end
