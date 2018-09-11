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
    :info_dot,
    :principal_office,
    :industries_enabled,
    :jurisdictions_enabled,
    :accounts_enabled,
    :range,
    :aum_enabled,
    :hours_enabled,
    :turnkey_page_id,
    project_templates_attributes: [
      :_destroy,
      :id,
      :title,
      :title_aum,
      :flavor,
      :project_type,
      :location_type,
      :public_description,
      :public_features,
      :description,
      :description_aum,
      :payment_schedule,
      :fixed_budget,
      :hourly_rate,
      :estimated_hours,
      :only_regulators,
      :annual_salary,
      :pricing_type,
      :fee_type,
      :minimum_experience,
      :duration_type,
      :estimated_days,
      :key_deliverables,
      :turnkey_solution_id,
      industry_ids: [],
      jurisdiction_ids: []
    ]
  )

  controller do
    # def create
    #  create! { smart_collection_url }
    # end
  end

  form html: { enctype: 'multipart/form-data' } do |f|
    f.inputs name: 'Turnkey Solution' do
      f.input :title
      f.input :info_dot
      f.input :turnkey_page_id, label: 'Category', as: :select, collection: TurnkeyPage.all.map { |u| [u.title, u.id] }
      f.input :range, label: 'Price range'
      f.input :aum_enabled
      f.input :principal_office, label: 'Principal office selectable'
      f.input :industries_enabled, label: 'Industries selectable'
      f.input :jurisdictions_enabled, label: 'Jurisdictions selectable'
      f.input :hours_enabled, label: 'No. of hours selectable'
      f.input :accounts_enabled, label: 'Request # of accounts'
      f.inputs 'Templates' do
        f.has_many :project_templates do |pt|
          pt.input :title
          pt.input :title_aum
          pt.input :flavor, as: :select, collection: %w[era sma fund bd]
          pt.input :industries
          pt.input :jurisdictions
          pt.input :project_type, as: :select, collection: %w[one_off full_time]
          pt.input :location_type, as: :select, collection: %w[remote remote_and_travel onsite]
          pt.input :public_description, as: :text
          pt.input :public_features, as: :text, label: 'Features (1 line per feature, sub-features begin with space)'
          pt.input :description, as: :text
          pt.input :description_aum, as: :text
          pt.input :payment_schedule, as: :select, collection: %w[upon_completion bi_weekly monthly fifty_fifty]
          pt.input :key_deliverables
          pt.input :pricing_type, as: :select, collection: %w[hourly fixed]
          pt.input :fixed_budget
          pt.input :hourly_rate
          pt.input :estimated_hours
          pt.input :only_regulators
          pt.input :annual_salary
          pt.input :fee_type, as: :select, collection: %w[upfront_fee monthly_fee]
          pt.input :minimum_experience
          pt.input :duration_type, as: :select, collection: %w[asap custom]
          pt.input :estimated_days
          pt.input :_destroy, as: :boolean, required: false, label: 'Remove'
        end
      end
    end
    f.actions
  end
end
