# frozen_string_literal: true
ActiveAdmin.register Project do
  actions :all, except: %i(new)
  filter :title
  filter :business
  # TODO: Change next two once activeadmin uses separate policy
  # Next two filters are custom because default policy joins specialists
  # We can't use the convenience methods because they would also join
  filter :by_specialist_first_name, as: :string, label: 'Specialist First Name'
  filter :by_specialist_last_name, as: :string, label: 'Specialist Last Name'
  filter :business_contact_first_name_in, as: :string, label: 'Business First Name'
  filter :business_contact_last_name_in, as: :string, label: 'Business Last Name'

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

  member_action :end, method: :post do
    ProjectEnd::Request.process! resource
    redirect_to collection_path, notice: 'Project end requested'
  end

  index do
    column :title do |project|
      link_to project.title, [:admin, project]
    end
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
      actions = []
      if project.specialist && !project.complete?
        actions << link_to('End Project', end_admin_project_path(project), method: :post, class: 'member_link')
      end
      if project.ratings.count > 0
        actions << link_to('Ratings', admin_ratings_path(q: { project_id_eq: project.id }), class: 'member_link')
      else
        actions << '<span class="member_span">No Ratings yet</span>'.html_safe
      end
      actions.join('').html_safe
    end
  end

  show do
    attributes_table do
      row :business
      row :type
      row :status
      row :title
      row :location
      row :location_type
      row :decscription
      row :key_deliverables
      row :starts_on
      row :ends_on
      row :payment_schedule
      row :fixed_budget
      row :hourly_rate
      row :estimated_hours
      row :minimum_experience
      row :only_regulators
      row :annual_salary
      row :fee_type
      row :pricing_type
      row :annual_salary
      row :calculated_budget
      row :specialist
    end
  end

  permit_params :title,
                :location,
                :description,
                :key_deliverables,
                :starts_on,
                :ends_on,
                :payment_schedule,
                :fixed_budget,
                :hourly_rate,
                :estimated_hours,
                :minimum_experience,
                :only_regulators,
                :annual_salary,
                :fee_type,
                :pricing_type,
                industry_ids: [],
                jurisdiction_ids: []
  form do |f|
    f.inputs do
      f.input :title
      f.input :location
      f.input :type, as: :readonly
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
      f.input :pricing_type, collection: %w(hourly fixed)
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
