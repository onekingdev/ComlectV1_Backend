# frozen_string_literal: true

class AddTitleToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :title, :string
    add_column :subscriptions, :billing_period_ends, :integer
  end
end
