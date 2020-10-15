# frozen_string_literal: true

class Business::FileFoldersController < ApplicationController
  before_action :require_business!
  before_action :set_folder, only: %i[destroy edit update show download_folder check_zip]

  def new
    @file_folder = FileFolder.new
    @file_doc = FileDoc.new
  end

  def create
    @file_folder = FileFolder.new(file_folder_params)
    @file_folder.business_id = current_business.id
    if @file_folder.save
      redirect_to route_to_parent(@file_folder.parent_id)
    else
      @file_doc = FileDoc.new
      render 'new'
    end
  end

  def destroy
    file_folder_parent_id = @file_folder.parent_id
    @file_folder.destroy unless @file_folder.locked?
    redirect_to route_to_parent(file_folder_parent_id)
  end

  def update
    @file_folder.update(file_folder_params) unless @file_folder.locked?
    redirect_to route_to_parent(@file_folder.parent_id)
  end

  def show
    @file_folders = @file_folder.file_folders
    @file_docs = @file_folder.file_docs
  end

  def download_folder
    respond_to do |format|
      format.js do
        @file_folder.zip = nil
        @file_folder.save
        ZipFolderWorker.perform_async(params[:id], current_user.id)
      end
    end
  end

  def check_zip
    respond_to do |format|
      format.json do
        path = @file_folder.zip.present? ? @file_folder.zip.url : nil
        render json: { complete: @file_folder.zip.present?, path: path }
      end
    end
  end

  private

  def file_folder_params
    params.require(:file_folder).permit(:name, :parent_id)
  end

  def route_to_parent(parent_id)
    parent_id.nil? ? business_audit_requests_path : business_file_folder_path(parent_id)
  end

  def set_folder
    @file_folder = current_business.file_folders.find(params[:id])
  end
end
