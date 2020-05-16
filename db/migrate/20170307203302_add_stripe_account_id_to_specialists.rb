# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
class AddStripeAccountIdToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :stripe_account_id, :string
    add_column :specialists, :stripe_secret_key, :string
    add_column :specialists, :stripe_publishable_key, :string
    reversible do |dir|
      dir.up do
        Specialist.all.each do |specialist|
          account = specialist.stripe_account
          next unless account
          specialist.update_attribute :stripe_account_id, account.stripe_id
          specialist.update_attribute :stripe_secret_key, account.secret_key
          specialist.update_attribute :stripe_publishable_key, account.publishable_key
          stripe_account = Stripe::Account.retrieve(account.stripe_id)
          account.update_attribute :stripe_id, stripe_account.external_accounts.first&.id
        end
        remove_column :stripe_accounts, :secret_key
        remove_column :stripe_accounts, :publishable_key
      end

      dir.down do
        add_column :stripe_accounts, :secret_key, :string
        add_column :stripe_accounts, :publishable_key, :string
        StripeAccount.all.each do |account|
          account.update_attribute :secret_key, account.specialist.stripe_secret_key
          account.update_attribute :publishable_key, account.specialist.stripe_publishable_key
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
