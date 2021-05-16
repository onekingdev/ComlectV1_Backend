# frozen_string_literal: true

class FileFolderSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :parent_id,
             :created_at,
             :updated_at,
             :locked,
             :zip_addr

  def zip_addr
    object.zip_url.nil? ? nil : object.zip_url.split('?')[0]
  end
end
