class Document < ActiveRecord::Base
  include FileUploader[:file]
  belongs_to :project
  belongs_to :owner, polymorphic: true
  validates_presence_of :file_data

  def get_file_name
    file_data['metadata']['filename']
  end

  def get_owner_name
    owner.to_s
  end
end
