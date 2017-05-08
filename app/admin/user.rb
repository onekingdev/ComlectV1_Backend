# frozen_string_literal: true
ActiveAdmin.register User do
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

  member_action :impersonate, method: :post do
    impersonate_user resource
    redirect_to resource_path(resource), notice: "Impersonating this user"
  end

  collection_action :stop_impersonating, method: :post do
    stop_impersonating_user
    redirect_to collection_path, notice: 'Stopped user impersonation'
  end

  action_item :impersonate, only: :show do
    link_to 'Impersonate', impersonate_admin_user_path(resource), method: :post
  end

  action_item :stop_impersonating, only: :index do
    link_to 'Stop Impersonating', stop_impersonating_admin_users_path, method: :post
  end

  controller do
    def destroy_resource(resource)
      User::Delete.(resource)
    end

    def resource
      # So users can be edited without providing a password
      @user ||= super.extend(NoPasswordRequired)
    end
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
      link_to (user.suspended? ? 'Reactivate' : 'Suspend'), toggle_suspend_admin_user_path(user), method: :post
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
