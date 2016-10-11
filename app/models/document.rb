# frozen_string_literal: true
class Document < ActiveRecord::Base
  include FileUploader[:file]
  belongs_to :project
  belongs_to :owner, polymorphic: true
  validates :file_data, presence: true

  def file_name
    file_data['metadata']['filename']
  end

  def owner_name
    owner.to_s
  end
end
