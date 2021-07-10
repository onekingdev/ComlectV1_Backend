# frozen_string_literal: true

ActiveAdmin.register Jurisdiction do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :name do |record|
      link_to record, [:admin, record]
    end
    column :sub_jurisdictions_specialist do |record|
      raw(record.sub_jurisdictions_specialist.split("\n").join('<br/>')) unless record.sub_jurisdictions_specialist.nil?
    end
    actions
  end

  permit_params :name, :sub_jurisdictions_specialist

  controller do
    def create
      create! { smart_collection_url }
    end
  end
end
