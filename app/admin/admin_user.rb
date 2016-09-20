# frozen_string_literal: true
ActiveAdmin.register AdminUser, as: 'Customer Service Accounts' do
  filter :email

  scope :admin
  scope :cusomter_representative

  config.clear_action_items!

  action_item only: :index do
    link_to "New Customer Service Representative", new_admin_customer_service_account_path
  end

  member_action :toggle_suspend, method: :post do
    resource.suspended = !resource.suspended
    resource.save
    redirect_to collection_path, notice: resource.suspended ? 'Suspended' : 'Reactivated'
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
    actions do |admin_user|
      unless admin_user.super_admin?
        link_to (admin_user.suspended ? 'Reactivate' : 'Suspend'),
                toggle_suspend_admin_customer_service_account_path(admin_user),
                method: :post
      end
    end
  end

  permit_params :email, :password, :password_confirmation

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input 'Admin', :super_admin
    end
    f.actions
  end
end
