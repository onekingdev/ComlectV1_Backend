# frozen_string_literal: true

class BankAccount::Save < BankAccount
  include ApplicationForm

  validates :stripe_account, :country, :currency, :account_number, presence: true
  validates :routing_number, presence: true, unless: :require_iban?

  def initialize(_attributes = {})
    super
    self.country = stripe_account.country
  end

  def save(*)
    self.primary = true unless stripe_account.bank_accounts.any?
    super
  end

  def require_iban?
    %w[AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE].include? country
  end
end
