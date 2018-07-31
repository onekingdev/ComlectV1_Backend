# frozen_string_literal: true

ActiveAdmin.register TurnkeyPage do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :title do |record|
      link_to record.title, [:admin, record]
    end
    actions
  end

  permit_params :title, :url, :description, :cost

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Turnkey Category' do
      input :title
      input :url
      input :description
      input :cost
    end
    f.actions
  end
end
