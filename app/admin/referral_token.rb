# frozen_string_literal: true

ActiveAdmin.register ReferralToken, as: 'Tokens' do
  menu parent: 'Referrals'

  actions :all, except: %i[create destroy]

  permit_params :amount_in_cents, :token

  form do |f|
    f.inputs do
      f.input :token
      f.input :amount_in_cents
      f.input :referrer_id, label: 'Referrer Id'
      f.input :referrer_type, collection: %w[Business Specialist], include_blank: false
    end

    f.actions
  end
end
