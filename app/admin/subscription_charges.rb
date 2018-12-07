# frozen_string_literal: true

ActiveAdmin.register SubscriptionCharge do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :status
  filter :plan

  index do
    id_column
    column 'Business' do |sc|
      sc.forum_subscription&.business
    end
    column :status
    column :plan
    column 'Fee' do |sc|
      number_to_currency((sc.amount / 100), precision: 2) if sc.amount
    end
    # column :stripe_subscription_id
  end
end
