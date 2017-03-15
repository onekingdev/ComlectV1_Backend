# frozen_string_literal: true
class BankAccount::Update < BankAccount::Save
  include ApplicationForm

  def self.retrieve(stripe_account, id)
    find_by!(stripe_account_id: stripe_account.id, id: id)
  end

  def make_primary!
    stripe = Stripe::Account.retrieve(stripe_account.stripe_id)
    account = stripe.external_accounts.retrieve(stripe_id)
    account.default_for_currency = true
    account.save
    stripe_account.bank_accounts.update_all primary: false
    update_attribute :primary, true
  end
end
