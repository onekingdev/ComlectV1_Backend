# frozen_string_literal: true

class LocalProjectSerializer < ApplicationSerializer
  has_many :projects, serializer: ProjectSerializer
  has_one :business, serializer: Specialist::BusinessSerializer
  has_one :visible_project, serializer: ProjectSerializer
  attributes :id,
             :business_id,
             :title,
             :description,
             :starts_on,
             :ends_on,
             :status,
             :created_at,
             :updated_at,
             :projects,
             :cost,
             :visible_project

  def status
    object.deep_status
  end
end
