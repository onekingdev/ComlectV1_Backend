# frozen_string_literal: true

class CreateSeats < ActiveRecord::Migration[6.0]
  def change
    create_table :seats do |t|
      t.bigint :business_id
      t.bigint :subscription_id
      t.bigint :team_member_id
      t.datetime :subscribed_at
      t.datetime :assigned_at

      t.timestamps null: false
    end

    add_index :seats, :business_id
    add_index :seats, :team_member_id
  end
end
