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
             :reminders

  def hide_on_calendar
    current_user.hidden_local_projects.include?(object.id)
  end
end
