# frozen_string_literal: true
ActiveAdmin.register AdminUser, as: 'Customer Service Accounts' do
  filter :email

  scope :super_admin
  scope :cusomter_representative

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  permit_params :email, :password, :password_confirmation

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :super_admin
    end
    f.actions
  end
end
