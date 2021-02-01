# frozen_string_literal: true

class Document < ApplicationRecord
  include FileUploader[:file]
  belongs_to :project
  belongs_to :owner, polymorphic: true
  validates :file_data, presence: true
  belongs_to :specialist # recipient if uploaded by business @ interview

  def file_name
    file_data['metadata']['filename']
  end

  def owner_name
    owner.to_s
  end
end
