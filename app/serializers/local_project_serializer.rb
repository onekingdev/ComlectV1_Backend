# frozen_string_literal: true

class LocalProjectSerializer < ApplicationSerializer
  has_many :projects, serializer: ProjectSerializer
  attributes :id, :business_id, :title, :description, :starts_on, :ends_on, :status, :created_at, :updated_at, :projects
end
