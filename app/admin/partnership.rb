# frozen_string_literal: true

ActiveAdmin.register Partnership do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :company do |record|
      link_to record, [:admin, record]
    end
    actions
  end

  permit_params :company, :category, :description, :discount, :discount_pub, :href, :logo, :logo_data

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Partnership' do
      input :company
      input :description
      input :discount
      input :discount_pub
      input :href
      input :category
      input :logo, as: :file, label: 'Logo'
    end
    f.actions
  end
end
