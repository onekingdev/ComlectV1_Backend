# frozen_string_literal: true

class DocumentSerializer < ApplicationSerializer
  attributes :id,
             :owner_id,
             :owner_type,
             :uploadable_type,
             :uploadable_id,
             :file_data,
             :created_at,
             :updated_at,
             :url,
             :owner_name
  def url
    object.file_url
  end

  def owner_name
    object.owner_type == 'Specialist' ? object.owner.name : object.owner.contact_full_name
  end
end
