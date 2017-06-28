# frozen_string_literal: true

ActiveAdmin.register User, namespace: :support do
  batch_action :send_email_to, form: {
    subject: :text,
    body: :textarea
  } do |ids, inputs|
    User.where(id: ids).pluck(:email).uniq.each do |email|
      AdminMailer.deliver_later :admin_email, email, inputs[:subject], inputs[:body]
    end
    redirect_to collection_path, notice: "Email will be sent to selected #{'user'.pluralize(ids.length)}"
  end

  member_action :toggle_suspend, method: :post do
    resource.suspended? ? resource.unfreeze! : resource.freeze!
    redirect_to collection_path, notice: resource.suspended? ? 'Suspended' : 'Reactivated'
  end

  scope("Active") { |scope| scope.where(suspended: false) }
  scope("Suspended") { |scope| scope.where(suspended: true) }

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
    actions do |user|
      link_to (user.suspended? ? 'Reactivate' : 'Suspend'), toggle_suspend_support_user_path(user), method: :post
    end
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
