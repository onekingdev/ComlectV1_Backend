# frozen_string_literal: true

class FileFolder < ActiveRecord::Base
  belongs_to :business
  belongs_to :parent, class_name: 'FileFolder'
  has_many :file_folders, class_name: 'FileFolder', foreign_key: :parent_id
  has_many :file_docs, dependent: :destroy
  include FileUploader[:zip]
  scope :root, -> { where(parent_id: nil) }
  validates :name, uniqueness: { scope: %i[business_id parent_id] }
  validate :parent_belongs_to_business
  default_scope { order(created_at: :desc) }

  def all_children_recursion
    file_folders.flat_map do |child_ff|
      child_ff.all_children_recursion << child_ff
    end
  end

  def create_zip(folder, temp_file)
    Zip::OutputStream.open(temp_file) { |zos| }
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      write_entries folder.file_folders + folder.file_docs, '', zip
    end
    uploader = FileUploader.new(:store)
    uploaded_file = uploader.upload(File.open(temp_file.path))
    folder.zip = uploaded_file
    folder.zip_data = uploaded_file.to_json
    folder.save
    temp_file.unlink
    temp_file.delete
  end

  private

  def parent_belongs_to_business
    return true if parent_id.blank?
    parent.business_id == business_id
  end

  def write_entries(entries, path, zipfile)
    entries.each do |entry|
      zipfile_path = path == '' ? entry.name : File.join(path, entry.name)
      if entry.class.name == 'FileFolder'
        recursively_deflate_directory(entry, zipfile_path, zipfile)
      else
        begin
          put_into_archive(entry, zipfile, zipfile_path)
        rescue SystemCallError => e
          Rails.logger.info e
        end
      end
    end
  end

  def recursively_deflate_directory(entry, zipfile_path, zipfile)
    zipfile.mkdir zipfile_path
    write_entries entry.file_folders + entry.file_docs, zipfile_path, zipfile
  end

  def put_into_archive(entry, zipfile, zipfile_path)
    zipfile.add(zipfile_path, open_file(entry))
  end

  def open_file(entry)
    if Rails.env.development?
      path = "#{Rails.root}/public#{entry.file_url.split('?').first}"
      File.open(path)
    else
      require 'open-uri'
      URI.parse(entry.file_url).open
    end
  end
end
