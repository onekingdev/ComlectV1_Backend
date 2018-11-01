# frozen_string_literal: true

ActiveAdmin.register Referral do
  actions :all, except: %i[new edit update delete]

  index do
    column :id
    column :referrer do |referral|
      link_to referral.referral_token.referrer.to_s, [:admin, referral.referral_token.referrer]
    end
    column :referred do |referral|
      link_to referral.referrable.full_name, [:admin, referral.referrable]
    end
    # rubocop:disable Style/SymbolProc
    column :referred_type do |referral|
      referral.referrable_type
    end
    # rubocop:enable Style/SymbolProc
    column :token do |referral|
      link_to referral.referral_token.token, admin_token_path(referral.referral_token)
    end
    column :token_amount do |referral|
      number_to_currency referral.referral_token.amount
    end
    column :created_at
  end
end
