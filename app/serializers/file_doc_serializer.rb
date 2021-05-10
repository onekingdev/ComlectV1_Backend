# frozen_string_literal: true

class FileDocSerializer < ApplicationSerializer
  attributes :id,
             :file_folder_id,
             :file_addr,
             :created_at,
             :updated_at,
             :name

  def file_addr
    object.file_url.split('?')[0]
  end
end
