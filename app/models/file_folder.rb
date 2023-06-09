# frozen_string_literal: true

class FileFolder < ActiveRecord::Base
  belongs_to :business
  belongs_to :parent, class_name: 'FileFolder', optional: true
  has_many :file_folders, class_name: 'FileFolder', foreign_key: :parent_id
  has_many :file_docs, dependent: :destroy
  include FileUploader[:zip]
  scope :root, -> { where(parent_id: nil) }
  validates :name, uniqueness: { scope: %i[business_id parent_id] }
  validate :parent_belongs_to_business
  default_scope { order(created_at: :desc) }
  after_save :update_size

  def all_children_recursion
    file_folders.flat_map do |child_ff|
      child_ff.all_children_recursion << child_ff
    end
  end

  def create_zip(folder, user_id)
    directory_name = "/tmp/zip_archiver_#{user_id}_#{folder.id}"
    Dir.mkdir(directory_name) unless File.exist?(directory_name)
    zipfile_name = "#{directory_name}/#{folder.name}.zip"
    File.delete(zipfile_name) if File.exist?(zipfile_name)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zip|
      write_entries folder.file_folders + folder.file_docs, '', zip
    end
    uploader = FileUploader.new(:store)
    uploaded_file = uploader.upload(File.open(zipfile_name))
    folder.zip = uploaded_file
    folder.zip_data = uploaded_file.to_json
    folder.save
    FileUtils.rm_rf(directory_name) if File.exist?(directory_name)
    zipfile_name.unlink if File.exist? zipfile_name
    zipfile_name.delete if File.exist? zipfile_name
  end

  def update_size
    total = file_folders.collect(&:size).compact.inject(0, :+) + file_docs.collect(&:size).compact.inject(0, :+)
    update_column('size', total)
    parent.update_size if parent.present?
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
      io = URI.open(entry.file_url)
      if io.is_a?(StringIO)
        downloaded = Tempfile.new
        File.write(downloaded.path, io)
      else
        downloaded = io
      end
      downloaded
    end
  end
end
