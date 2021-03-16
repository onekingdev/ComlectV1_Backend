# frozen_string_literal: true

class ProjectEndSerializer < ApplicationSerializer
  attributes :id,
             :project_id,
             :expires_at,
             :status,
             :requester
end
