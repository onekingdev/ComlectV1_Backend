# frozen_string_literal: true
ActiveAdmin.register Flag do
  config.batch_actions = true
  batch_action :send_email_to_offending_users, form: {
    subject: :text,
    body: :textarea
  } do |ids, inputs|
    user_ids = ids.map { |id| Flag.find(id).offending_user.user.id }
    User.where(id: user_ids).pluck(:email).uniq.each do |email|
      AdminMailer.deliver_later :admin_email, email, inputs[:subject], inputs[:body]
    end
    redirect_to collection_path, notice: "Email will be sent to selected #{'user'.pluralize(ids.length)}"
  end

  actions :all, except: %i(edit delete new create update)
  filter :flagger_type
  filter :flagged_content_type
  filter :created_at
  filter :reason

  index do
    selectable_column
    column :project
    column :reason
    column :flagger
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :created_at
      row :project
      row :reason
      row :flagger
      row :flagged_content_type
      row :flagged_content
      if flag.flagged_content.is_a?(Question)
        row :answer do |flag|
          flag.flagged_content.answer
        end
      end
      row :offending_user
    end
  end
end
