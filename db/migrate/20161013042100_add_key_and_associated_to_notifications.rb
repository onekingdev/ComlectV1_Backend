# frozen_string_literal: true

class AddKeyAndAssociatedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :key, :string
    add_reference :notifications, :associated, polymorphic: true, index: true
  end
end
