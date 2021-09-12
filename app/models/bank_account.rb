# frozen_string_literal: true

class BankAccount < ApplicationRecord
  belongs_to :stripe_account
  has_one :specialist, through: :stripe_account

  validates :account_number, confirmation: true

  validates \
    :routing_number, :account_number,
    :account_number_confirmation, :currency, :country,
    presence: true

  scope :sorted, -> { order('"primary" DESC, created_at DESC') }

  before_create :create_bank_account
  after_commit -> { stripe_account.update_verification_status }, on: :create

  private

  def create_bank_account
    account = Stripe::Account.retrieve(stripe_account.stripe_id)
    external_account = account.external_accounts.create(external_account: stripe_attributes)

    self.stripe_id = external_account.id
    self.primary = true
  rescue Stripe::InvalidRequestError => e
    field_name, msg = detect_reason(e.response.data[:error])
    errors.add(field_name, msg)
    raise ActiveRecord::Rollback
  end

  def stripe_attributes
    {
      currency: currency,
      object: 'bank_account',
      default_for_currency: true,
      routing_number: routing_number,
      account_number: account_number,
      country: stripe_account.country
    }
  end

  def detect_reason(error)
    key = error[:code].gsub('_invalid', '')
    key = 'base' unless has_attribute?(key)
    [key, error[:message]]
  end
end
