# frozen_string_literal: true

class AddStatusColumnToPortedSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :ported_subscriptions, :status, :integer, default: 0
  end
end
