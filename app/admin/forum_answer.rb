# frozen_string_literal: true

ActiveAdmin.register ForumAnswer do
  menu parent: 'Q&A'

  config.filters = false

  index do
    selectable_column
    column :body do |record|
      link_to record.body, [:admin, record]
    end
    actions
  end

  permit_params :body, :forum_question_id, :reply_to, :upvotes_cnt, :file

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Forum Answer' do
      input :body
      input :forum_question_id
      input :reply_to
      input :upvotes_cnt
      input :file
    end
    f.actions
  end
end
