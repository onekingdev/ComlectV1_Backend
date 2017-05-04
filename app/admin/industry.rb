# frozen_string_literal: true
ActiveAdmin.register Industry do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :name do |record|
      link_to record, [:admin, record]
    end
    actions
  end

  permit_params :name

  controller do
    def create
      create! { smart_collection_url }
    end
  end
end
