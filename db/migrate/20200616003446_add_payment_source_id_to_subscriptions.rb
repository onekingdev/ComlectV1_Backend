# frozen_string_literal: true

class AddPaymentSourceIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :payment_source_id, :integer
  end
end
