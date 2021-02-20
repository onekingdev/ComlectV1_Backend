# frozen_string_literal: true

class LocalProjectSerializer < ApplicationSerializer
  attributes :id, :business_id, :title, :description, :starts_on, :ends_on, :status, :created_at, :updated_at
end
