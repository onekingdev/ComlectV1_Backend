# frozen_string_literal: true
class BankAccount < ActiveRecord::Base
  belongs_to :stripe_account
  has_one :specialist, through: :stripe_account

  scope :sorted, -> { order('"primary" DESC, created_at DESC') }

  private

  def create_bank_account
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    ba = account.external_accounts.create(external_account: stripe_attributes)
    update_attribute :stripe_id, ba.id
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    destroy # So #persisted? does not return true
    raise ActiveRecord::Rollback
  end

  def delete_bank_account
    account = Stripe::Account.retrieve(specialist.stripe_account_id)
    account.external_accounts.retrieve(stripe_id).delete
  end

  def stripe_attributes
    {
      object: 'bank_account',
      country: country,
      currency: account_currency,
      routing_number: account_routing_number,
      account_number: account_number
    }
  end
end
