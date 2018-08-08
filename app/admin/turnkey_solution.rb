# frozen_string_literal: true

ActiveAdmin.register TurnkeySolution do
  menu parent: 'Data'

  config.filters = false

  index do
    selectable_column
    column :title do |record|
      link_to record.title.to_s, [:admin, record]
    end
    column :category do |record|
      link_to record.turnkey_page.title, [:admin, record]
    end
    actions
  end

  permit_params(
    :title,
    :industries_enabled,
    :jurisdictions_enabled,
    :project_industries,
    :project_jurisdictions,
    :range,
    :aum,
    :era,
    :sma,
    :fund,
    :hours,
    :description,
    :features,
    :project_title,
    :project_type,
    :project_location_type,
    :project_description,
    :project_payment_schedule,
    :project_fixed_budget,
    :project_hourly_rate,
    :project_estimated_hours,
    :project_only_regulators,
    :project_annual_salary,
    :project_fee_type,
    :project_minimum_experience,
    :project_duration_type,
    :project_estimated_days,
    :project_key_deliverables,
    :turnkey_page_id,
    industry_ids: [],
    jurisdiction_ids: []
  )

  controller do
    def create
      create! { smart_collection_url }
    end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    inputs name: 'Turnkey Solution' do
      input :title
      input :turnkey_page_id, label: 'Category', as: :select, collection: TurnkeyPage.all.map { |u| [u.title, u.id] }
      input :range
      input :era
      input :sma
      input :fund
      input :aum
      input :principal_office, label: 'Principal office selectable'
      input :industries_enabled, label: 'Industries selectable'
      input :jurisdictions_enabled, label: 'Jurisdictions selectable'
      input :hours, label: 'No. of hours selectable'
      input :description
      input :features, label: 'Features (1 line per feature, sub-features begin with space)'
      input :project_title
      input :industries # , as: :select, multiple: true, collection: Industry.sorted.collect(&:name)
      input :jurisdictions # , as: :select, multiple: true, collection: Jurisdiction.sorted.collect(&:name)
      input :project_type, as: :select, collection: %w[one_off full_time]
      input :project_location_type, as: :select, collection: %w[remote remote_and_travel onsite]
      input :project_description, as: :text
      input :project_payment_schedule, as: :select, collection: %w[upon_completion bi_weekly monthly fifty_fifty]
      input :project_key_deliverables
      input :project_pricing_type, as: :select, collection: %w[hourly fixed]
      input :project_fixed_budget
      input :project_hourly_rate
      input :project_estimated_hours
      input :project_only_regulators
      input :project_annual_salary
      input :project_fee_type, as: :select, collection: %w[upfront_fee monthly_fee]
      input :project_minimum_experience
      input :project_duration_type, as: :select, collection: %w[asap custom]
      input :project_estimated_days
    end
    f.actions
  end
end
