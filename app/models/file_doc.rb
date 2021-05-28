# frozen_string_literal: true

class FileDoc < ActiveRecord::Base
  belongs_to :business
  belongs_to :file_folder
  include FileUploader[:file]
  validates :file, presence: true
  validate :folder_belongs_to_business
  validates :name, uniqueness: { scope: %i[business_id file_folder_id] }
  scope :root, -> { where(file_folder_id: nil) }
  default_scope { order(created_at: :desc) }

  private

  def folder_belongs_to_business
    return true if file_folder_id.blank?
    file_folder.business_id == business_id
  end
end
