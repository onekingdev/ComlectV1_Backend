# frozen_string_literal: true

class Api::Business::FileDocsController < ApiController
  before_action :require_business!
  before_action :set_file_doc, only: %i[destroy edit update]

  def create
    file_doc = FileDoc.new(file_doc_params)
    file_doc.business_id = current_business.id
    file_doc.name = file_doc_params[:file].original_filename
    if file_doc.save!
      respond_with file_doc, serializer: FileDocSerializer, status: :created
    else
      respond_with errors: file_doc.errors, status: :unprocessable_entity
    end
  end

  def update
    if @file_doc.update(file_doc_params)
      respond_with @file_doc, serializer: FileDocSerializer, status: :ok
    else
      respond_with errors: @file_doc.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @file_doc.destroy
      respond_with message: I18n.t('api.business.file_docs.destroyed'), status: :ok
    else
      respond_with errors: @file_doc.errors, status: :unprocessable_entity
    end
  end

  private

  def file_doc_params
    params.require(:file_doc).permit(:file_folder_id, :file, :name)
  end

  def set_file_doc
    @file_doc = current_business.file_docs.find(params[:id])
  end
end
