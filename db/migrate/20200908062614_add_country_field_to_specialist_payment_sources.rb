# frozen_string_literal: true

class AddCountryFieldToSpecialistPaymentSources < ActiveRecord::Migration
  def change
    add_column :specialist_payment_sources, :validated, :boolean, default: false
    add_column :specialist_payment_sources, :bank_account, :boolean, default: false
    add_column :specialist_payment_sources, :country, :string
    add_column :specialist_payment_sources, :currency, :string
    add_column :specialist_payment_sources, :account_holder_name, :string
    add_column :specialist_payment_sources, :account_holder_type, :string
  end
end
