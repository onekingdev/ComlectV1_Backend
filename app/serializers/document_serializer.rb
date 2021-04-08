# frozen_string_literal: true

class DocumentSerializer < ApplicationSerializer
  attributes :id,
             :owner_id,
             :owner_type,
             :local_project_id,
             :file_data,
             :created_at,
             :updated_at
end
