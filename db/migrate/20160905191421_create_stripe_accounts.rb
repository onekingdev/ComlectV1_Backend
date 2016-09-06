# frozen_string_literal: true
class CreateStripeAccounts < ActiveRecord::Migration
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :stripe_accounts do |t|
      t.references :specialist, index: true, foreign_key: true
      t.string :status, null: false, default: 'Pending'
      t.string :account_country
      t.string :account_currency
      t.string :account_routing_number
      t.string :account_number
      t.string :city
      t.string :address1
      t.string :postal_code
      t.string :state
      t.string :country
      t.date :dob
      t.string :first_name
      t.string :last_name
      t.string :ssn_last_4
      t.date :tos_acceptance_date
      t.string :tos_acceptance_ip
      t.string :personal_id_number
      t.jsonb :verification_document_data

      t.timestamps null: false
    end
  end
end
