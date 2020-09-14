# frozen_string_literal: true

class BankAccount < ApplicationRecord
  belongs_to :stripe_account
  has_one :specialist, through: :stripe_account

  scope :sorted, -> { order('"primary" DESC, created_at DESC') }

  before_create :create_bank_account
  after_commit -> { stripe_account.update_verification_status }, on: :create

  private

  def create_bank_account
    account = Stripe::Account.retrieve(stripe_account.stripe_id)
    ba = account.external_accounts.create(external_account: stripe_attributes)
    self.stripe_id = ba.id
    true
  rescue Stripe::InvalidRequestError => e
    errors.add :base, e.message
    false
  end

  def stripe_attributes
    {
      object: 'bank_account',
      country: country,
      currency: currency,
      routing_number: routing_number,
      account_number: account_number
    }
  end
end
