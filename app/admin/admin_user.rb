# frozen_string_literal: true

ActiveAdmin.register AdminUser, as: 'Administrator' do
  menu parent: 'Roles'
  filter :email

  controller do
    def scoped_collection
      super.admin
    end
  end

  before_create do |admin_user|
    admin_user.super_admin = true
  end

  member_action :toggle_suspend, method: :post do
    resource.suspended = !resource.suspended
    resource.save
    redirect_to collection_path, notice: resource.suspended ? 'Suspended' : 'Reactivated'
  end

  index do
    if current_admin_user.super_admin?
      selectable_column
      id_column
      column :email
      column :current_sign_in_at
      column :sign_in_count
      column :created_at
      actions do |admin_user|
        if admin_user != current_admin_user
          link_to (admin_user.suspended ? 'Reactivate' : 'Suspend'),
                  toggle_suspend_admin_administrator_path(admin_user),
                  method: :post
        end
      end
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
