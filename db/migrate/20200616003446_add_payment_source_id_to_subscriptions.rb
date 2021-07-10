# frozen_string_literal: true

class AddPaymentSourceIdToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :payment_source_id, :integer
  end
end
