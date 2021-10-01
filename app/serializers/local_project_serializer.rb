# frozen_string_literal: true

class LocalProjectSerializer < ApplicationSerializer
  has_many :projects, serializer: ProjectSerializer
  has_one :business, serializer: Specialist::BusinessSerializer
  has_one :visible_project, serializer: ProjectSerializer
  has_many :specialists, serializer: Business::SpecialistSerializer
  has_many :collaborators, serializer: Business::SpecialistSerializer
  attributes :id,
             :business_id,
             :title,
             :description,
             :starts_on,
             :ends_on,
             :status,
             :status_business,
             :created_at,
             :updated_at,
             :projects,
             :cost,
             :visible_project,
             :collaborators,
             :hide_on_calendar,
             :reminders,
             :owner,
             :business_is_collaborator

  def hide_on_calendar
    current_user.hidden_local_projects.include?(object.id)
  end

  def status_business
    return 'Complete' if object.complete?
    output_status = object.starts_on > Time.zone.now ? 'Not Started' : 'In Progress'
    output_status = 'Pending' if object.projects.where(specialist_id: nil, status: 'published').count.positive?
    output_status = 'Draft' if object.projects.where(specialist_id: nil, status: 'draft').count.positive?
    output_status
  end

  def owner
    return Business::SpecialistSerializer.new(object.owner).serializable_hash if object.owner.class.name.include?('Specialist')
    return Specialist::BusinessSerializer.new(object.owner).serializable_hash if object.owner.class.name.include?('Business')
  end
end
