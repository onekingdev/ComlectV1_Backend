# frozen_string_literal: true

class AdjustStripeAccountFields < ActiveRecord::Migration
  def change
    rename_column :stripe_accounts, :postal_code, :zipcode
    remove_column :stripe_accounts, :account_country, :string
    remove_column :stripe_accounts, :verification_document_data, :jsonb
    add_column :stripe_accounts, :additional_owners, :string
    add_column :stripe_accounts, :personal_city, :string
    add_column :stripe_accounts, :personal_address1, :string
    add_column :stripe_accounts, :personal_zipcode, :string
    add_column :stripe_accounts, :status_detail, :string
    add_column :stripe_accounts, :verification_document, :text

    reversible do |dir|
      dir.up { change_column :stripe_accounts, :tos_acceptance_date, :datetime }
      dir.down { change_column :stripe_accounts, :tos_acceptance_date, :date }
    end
  end
end
