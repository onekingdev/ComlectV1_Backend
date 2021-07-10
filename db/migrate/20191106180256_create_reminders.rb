# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.string :body
      t.integer :business_id
      t.date :remind_at

      t.timestamps null: false
    end
  end
end
