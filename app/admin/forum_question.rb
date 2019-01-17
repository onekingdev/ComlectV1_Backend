# frozen_string_literal: true

ActiveAdmin.register ForumQuestion do
  menu parent: 'Q&A'

  config.filters = false

  index do
    selectable_column
    column :title do |record|
      link_to record.title, [:admin, record]
    end
    actions
  end

  permit_params :title, :body, :state, :business_id

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Forum Question' do
      input :title
      input :body
      input :state
    end
    f.actions
  end
end
