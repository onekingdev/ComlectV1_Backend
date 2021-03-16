# frozen_string_literal: true

class ProjectExtensionSerializer < ApplicationSerializer
  attributes :id,
             :project_id,
             :new_end_date,
             :expires_at,
             :status,
             :requester
end
