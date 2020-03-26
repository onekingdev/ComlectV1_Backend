# frozen_string_literal: true

ActiveAdmin.register AuditRequest do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :body do |record|
      link_to record.body, [:admin, record]
    end
    actions
  end

  permit_params :body

  controller do
    def create
      create! { smart_collection_url }
    end
  end
end
