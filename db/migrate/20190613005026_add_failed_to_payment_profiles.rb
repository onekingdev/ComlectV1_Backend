# frozen_string_literal: true

class AddFailedToPaymentProfiles < ActiveRecord::Migration
  def change
    add_column :payment_profiles, :failed, :boolean, default: false
  end
end
