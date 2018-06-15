# frozen_string_literal: true

ActiveAdmin.register Article do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :title do |record|
      link_to record, [:admin, record]
    end
    actions
  end

  permit_params :open_pdf, :pdf, :pdf_data, :title, :src_title, :published_at, :image_data, :image, :src_href

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Partnership' do
      input :title
      input :src_title
      input :published_at
      input :image, as: :file, label: 'preview'
      input :pdf, as: :file, label: 'PDF'
      input :open_pdf, label: 'Open PDF instead of URL'
      input :src_href, label: 'Source URL'
    end
    f.actions
  end
end
