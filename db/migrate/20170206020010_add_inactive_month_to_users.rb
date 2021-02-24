# frozen_string_literal: true

class AddInactiveMonthToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :inactive_for_month, :boolean, default: false
  end
end
