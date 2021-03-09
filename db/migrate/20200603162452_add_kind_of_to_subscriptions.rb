# frozen_string_literal: true

class AddKindOfToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :kind_of, :integer, default: 0

    add_index :subscriptions, :kind_of
  end
end
