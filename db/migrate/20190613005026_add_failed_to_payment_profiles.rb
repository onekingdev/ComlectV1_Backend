# frozen_string_literal: true

class AddFailedToPaymentProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_profiles, :failed, :boolean, default: false
  end
end
