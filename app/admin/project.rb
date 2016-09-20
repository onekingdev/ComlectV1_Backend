# frozen_string_literal: true
ActiveAdmin.register Project do
  actions :all, except: %i(new show)
  filter :title
  filter :business

  scope :escalated
  scope :draft_and_in_review
  scope :published
  scope :pending
  scope :active
  scope :complete

  controller do
    def scoped_collection
      super.includes :ratings, :issues
    end
  end

  index do
    column :title
    column :location
    column :industries do |project|
      project.industries.map(&:name).join(', ')
    end
    column :jurisdictions do |project|
      project.jurisdictions.map(&:name).join(', ')
    end
    column :description
    column :key_deliverables
    column 'Escalated' do |project|
      project.escalated? ? status_tag('yes', :ok) : status_tag('no')
      link_to 'Issues', admin_issues_path(q: { project_id_eq: project.id }) if project.escalated?
    end
    actions do |project|
      if project.ratings.count > 0
        link_to 'Ratings', admin_ratings_path(q: { project_id_eq: project.id })
      else
        'No Ratings yet'
      end
    end
  end

  permit_params :title,
                :location,
                :description,
                :key_deliverables,
                industry_ids: [],
                jurisdiction_ids: []
  form do |f|
    f.inputs do
      f.input :title
      f.input :location
      f.input :industries
      f.input :jurisdictions
      f.input :description, as: :text
      f.input :key_deliverables
      f.input :starts_on
      f.input :ends_on
      f.input :payment_schedule, collection: Project::PAYMENT_SCHEDULES
      f.input :fixed_budget
      f.input :hourly_rate
      f.input :estimated_hours
      f.input :minimum_experience, collection: Project::MINIMUM_EXPERIENCE
      f.input :only_regulators
      f.input :annual_salary
      f.input :fee_type, collection: Project.fee_types
      f.input :pricing_type, as: :readonly
      f.input :calculated_budget, as: :readonly
      f.input :job_applications_count, as: :readonly
    end
    f.inputs 'Timesheets' do
      f.has_many :timesheets do |a|
        a.input :status, collection: Timesheet.statuses
        a.has_many :time_logs do |b|
          b.input :description
          b.input :hours, min: 0
        end
      end
    end
    f.actions
  end
end
