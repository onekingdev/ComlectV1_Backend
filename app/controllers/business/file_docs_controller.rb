# frozen_string_literal: true

class Business::FileDocsController < ApiController
  before_action :require_business!
  before_action :set_file_doc, only: %i[destroy edit update]

  def create
    @file_doc = FileDoc.new(file_doc_params)
    @file_doc.business_id = current_business.id
    @file_doc.name = file_doc_params[:file].original_filename
    @file_doc.save!
    redirect_to route_to_folder(@file_doc.file_folder_id)
  end

  def update
    @file_doc.update(file_doc_params)
    redirect_to route_to_folder(@file_doc.file_folder_id)
  end

  def destroy
    folder_id = @file_doc.file_folder_id
    @file_doc.destroy
    redirect_to route_to_folder(folder_id)
  end

  private

  def file_doc_params
    params.require(:file_doc).permit(:file_folder_id, :file, :name)
  end

  def route_to_folder(folder_id)
    folder_id.nil? ? business_audit_requests_path : business_file_folder_path(folder_id)
  end

  def set_file_doc
    @file_doc = current_business.file_docs.find(params[:id])
  end
end
