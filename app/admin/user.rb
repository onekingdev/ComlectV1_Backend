# frozen_string_literal: true
ActiveAdmin.register User do
  menu priority: 100

  batch_action :send_email_to, form: {
    subject: :text,
    body: :textarea
  } do |ids, inputs|
    User.where(id: ids).pluck(:email).uniq.each do |email|
      AdminMailer.admin_email(email, inputs[:subject], inputs[:body]).deliver
    end
    redirect_to collection_path, notice: "Email will be send to selected #{'user'.pluralize(ids.length)}"
  end

  filter :email
  filter :sign_in_count
  filter :created_at

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
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
