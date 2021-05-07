# frozen_string_literal: true

class Api::Business::FileFoldersController < ApiController
  before_action :require_business!
  before_action :set_folder, only: %i[destroy edit update show download_folder check_zip list_tree]

  def index
    current_business.create_annual_review_folder_if_none
    file_folders = current_business.file_folders.root
    file_docs = current_business.file_docs.root
    render json: { folders: serialize_folders(file_folders), files: serialize_files(file_docs) }
  end

  def create
    file_folder = FileFolder.new(file_folder_params)
    file_folder.business_id = current_business.id
    if file_folder.save
      respond_with file_folder, serializer: FileFolderSerializer, status: :created
    else
      respond_with errors: file_folder.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @file_folder.destroy unless @file_folder.locked?
    if @file_folder.persisted?
      respond_with errors: @file_folder.errors, status: :unprocessable_entity
    else
      respond_with message: 'Deleted ok', status: :ok
    end
  end

  def update
    @file_folder.update(file_folder_params) unless @file_folder.locked?
    respond_with @file_folder, serializer: FileFolderSerializer
  end

  def show
    file_folders = @file_folder.file_folders
    file_docs = @file_folder.file_docs
    render json: { folders: serialize_folders(file_folders), files: serialize_files(file_docs) }
  end

  def download_folder
    @file_folder.zip = nil
    @file_folder.save
    ZipFolderWorker.perform_async(params[:id], current_user.id)
    respond_with message: 'Compression has been queued'
  end

  def check_zip
    path = @file_folder.zip.present? ? @file_folder.zip.url : nil
    render json: { complete: @file_folder.zip.present?, path: path }
  end

  def list_tree
    render json: current_business.generate_folders_tree(@file_folder.id).to_json
  end

  private

  def serialize_folders(folders)
    folders.map(&proc { |folder| FileFolderSerializer.new(folder).serializable_hash })
  end

  def serialize_files(files)
    files.map(&proc { |file| FileDocSerializer.new(file).serializable_hash })
  end

  def file_folder_params
    params.require(:file_folder).permit(:name, :parent_id)
  end

  def set_folder
    @file_folder = current_business.file_folders.find(params[:id])
  end
end
