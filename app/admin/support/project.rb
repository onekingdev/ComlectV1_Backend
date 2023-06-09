# frozen_string_literal: true

ActiveAdmin.register Project, namespace: :support do
  actions :all, except: %i[new]

  filter :title
  filter :business
  filter :specialist_first_name, as: :string, label: 'Specialist First Name'
  filter :specialist_last_name, as: :string, label: 'Specialist Last Name'
  filter :business_contact_first_name_in, as: :string, label: 'Business First Name'
  filter :business_contact_last_name_in, as: :string, label: 'Business Last Name'
  filter :location_type, as: :select, collection: -> { Project.location_types }
  filter :location

  scope :all
  scope :escalated
  scope 'Draft', :draft_and_in_review
  scope :pending
  scope :active
  scope :complete

  after_update :call_after_update

  controller do
    def scoped_collection
      super.includes(:ratings, :issues, :business, :specialist)
    end

    def call_after_update(project)
      return unless project.previous_changes.key?(:ends_on)

      changed = project.previous_changes[:ends_on]
      if changed.second > changed.first
        extension = ProjectExtension.new(
          project: project,
          ends_on: changed.second
        )

        extension.__send__(:trigger_project_extension)
      else
        PaymentCycle.for(project).create_charges_and_reschedule!
      end
    end
  end

  member_action :end, method: :post do
    ProjectEnd.new(project: resource).__send__(:trigger_project_end)
    redirect_to collection_path, notice: 'Project end requested'
  end

  index do
    column :id
    column :title do |project|
      link_to project.title, [:support, project]
    end
    column :location do |project|
      project.remote? ? 'Remote' : project.location
    end
    column :industries do |project|
      project.industries.map(&:name).join(', ')
    end
    column :jurisdictions do |project|
      project.jurisdictions.map(&:name).join(', ')
    end
    column :description
    column :business, sortable: 'businesses.business_name'
    column :specialist, sortable: 'specialists.first_name'
    column 'Escalated' do |project|
      project.escalated? ? status_tag('yes', :ok) : status_tag('no')
    end
    actions do |project|
      actions = []
      if project.specialist && !project.complete?
        actions << link_to('End Project',
                           end_support_project_path(project),
                           method: :post,
                           class: 'member_link',
                           data: { confirm: 'Do you want to end this project?' })
      end
      actions << if project.ratings.count.positive?
        link_to('Ratings', support_ratings_path(q: { project_id_eq: project.id }), class: 'member_link')
      else
        '<span class="member_span">No Ratings yet</span>'.html_safe
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
      row :business_fee_free
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
      row :documents do |project|
        table_for project.documents do
          column(:file) do |document|
            link_to document.file_url, target: '_blank' do
              document.file.metadata['filename']
            end
          end
          column 'Sender', :owner
          column :created_at
        end
      end
      row :messages do |project|
        table_for project.messages do
          column :message
          column :sender
          column :created_at
          column :file do |message|
            if message.file
              link_to message.file_url, target: '_blank' do
                message.file.metadata['filename']
              end
            end
          end
        end
      end
    end

    div class: 'panel' do
      h3 'Timesheets'
      div class: 'panel_contents' do
        table_for Admin::TimesheetDecorator.decorate_collection(project.timesheets.order(first_submitted_at: :asc)) do
          column :status do |timesheet|
            status_tag timesheet.status.capitalize, class: timesheet.status_css
          end
          column 'Created' do |timesheet|
            link_to l(timesheet.created_at, format: :long), [:support, timesheet]
          end
          column 'Submitted' do |timesheet|
            l timesheet.first_submitted_at, format: :long
          end
          column :hours, class: 'number', &:total_hours
          column :total, class: 'number' do |timesheet|
            number_to_currency timesheet.total_amount
          end
        end
      end
    end
  end

  permit_params :title,
                :location_type,
                :location,
                :lat, :lng,
                :description,
                :key_deliverables,
                :starts_on,
                :ends_on,
                :payment_schedule,
                :business_fee_free,
                :fixed_budget,
                :hourly_rate,
                :estimated_hours,
                :minimum_experience,
                :only_regulators,
                :annual_salary,
                :fee_type,
                :pricing_type,
                timesheets_attributes: [:_destroy, :id, :status, time_logs_attributes: %i[id description hours]],
                industry_ids: [],
                jurisdiction_ids: []

  form do |f|
    f.inputs do
      f.input :title
      f.input :lat, as: :hidden
      f.input :lng, as: :hidden
      f.input :location_type, collection: Project::LOCATIONS
      f.input :location, input_html: {
        class: 'js-place-autocomplete', data: { lat: '#project_lat', lng: '#project_lng', self: 'full' }
      }
      f.input :type, as: :readonly
      f.input :industries
      f.input :jurisdictions
      f.input :description, as: :text
      f.input :key_deliverables
      f.input :starts_on
      f.input :ends_on unless f.object.full_time?
      f.input :pricing_type, collection: %w[hourly fixed] unless f.object.full_time?
      f.input :payment_schedule, collection: Project::PAYMENT_SCHEDULES unless f.object.full_time?
      f.input :business_fee_free
      f.input :fixed_budget unless f.object.full_time?
      f.input :hourly_rate unless f.object.full_time?
      f.input :estimated_hours unless f.object.full_time?
      f.input :minimum_experience, collection: Project::MINIMUM_EXPERIENCE
      f.input :only_regulators
      f.input :annual_salary if f.object.full_time?
      f.input :fee_type, collection: Project.fee_types if f.object.full_time?
      f.input :calculated_budget, as: :readonly
      f.input :job_applications_count, as: :readonly
    end

    if !f.object.full_time? && f.object.hourly_pricing?
      f.inputs 'Timesheets' do
        f.has_many :timesheets, sortable: :first_submitted_at do |a|
          a.input :status_changed_at, as: :readonly
          a.input :status, collection: Timesheet.statuses
          a.has_many :time_logs do |b|
            b.input :description
            b.input :hours, min: 0
          end
          if TimesheetPolicy.new(current_admin_user, a.object).destroy?
            a.input :_destroy, as: :boolean, required: false, label: 'Remove'
          end
        end
      end
    end

    f.actions
  end
end
