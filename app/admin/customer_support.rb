# frozen_string_literal: true

ActiveAdmin.register AdminUser, as: 'Customer Support' do
  menu parent: 'Roles', label: 'Customer Support'

  breadcrumb do
    [
      link_to('Admin', admin_root_path),
      link_to('Customer Support', admin_customer_supports_path)
    ]
  end

  filter :email

  controller do
    def scoped_collection
      super.customer_representative
    end
  end

  config.clear_action_items!

  action_item :new, only: :index do
    link_to 'New Customer Service Representative', new_admin_customer_support_path
  end

  member_action :toggle_suspend, method: :post do
    resource.suspended = !resource.suspended
    resource.save
    redirect_to collection_path, notice: resource.suspended ? 'Suspended' : 'Reactivated'
  end

  index title: 'Customer Support' do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions do |admin_user|
      link_to (admin_user.suspended ? 'Reactivate' : 'Suspend'),
              toggle_suspend_admin_customer_support_path(admin_user),
              method: :post
    end
  end

  permit_params :email, :password, :password_confirmation

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
