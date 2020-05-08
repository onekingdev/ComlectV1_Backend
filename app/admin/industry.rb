# frozen_string_literal: true

ActiveAdmin.register Industry do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :name do |record|
      link_to record, [:admin, record]
    end
    column :short_name do |record|
      link_to record.short_name, [:admin, record] if record.short_name.present?
    end
    column :sub_industries do |record|
      raw(record.sub_industries.split("\n").join('<br/>')) unless record.sub_industries.nil?
    end
    column :sub_industries_specialist do |record|
      raw(record.sub_industries_specialist.split("\n").join('<br/>')) unless record.sub_industries_specialist.nil?
    end
    actions
  end

  permit_params :name, :short_name, :sub_industries, :sub_industries_specialist

  controller do
    def create
      create! { smart_collection_url }
    end
  end
end
