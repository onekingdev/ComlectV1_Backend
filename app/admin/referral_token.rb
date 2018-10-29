# frozen_string_literal: true

ActiveAdmin.register ReferralToken, as: 'Tokens' do
  menu parent: 'Referrals'

  actions :all, except: %i[new create destroy]

  permit_params :amount_in_cents, :token

  form do |f|
    f.inputs do
      f.input :token
      f.input :amount_in_cents
    end

    f.actions
  end
end
