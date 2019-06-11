# frozen_string_literal: true

ActiveAdmin.register ForumSubscription do
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
  menu parent: 'Subscriptions'

  filter :level
  filter :billing_type

  index do
    id_column
    column 'Business', &:business
    column :level
    column :billing_type
    column :cancelled
  end
end
