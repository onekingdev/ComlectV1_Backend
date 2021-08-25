# frozen_string_literal: true

class Api::Business::ExamRequestFilesController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::ExamsPolicy) }
  before_action { authorize_business_tier(Business::ExamsPolicy) }
  before_action :find_exam_request, only: %i[create destroy]

  def create
    examrequestfile = @exam_request.exam_request_files.create(
      document_params.merge(name: document_params[:file].original_filename)
    )
    respond_with examrequestfile, serializer: ExamRequestFileSerializer
  end

  def destroy
    exam_request_file = @exam_request.exam_request_files.find(params[:id])
    if exam_request_file.destroy
      respond_with exam_request_file, serializer: ExamRequestFileSerializer
    else
      render json: { error: I18n.t('api.business.exam_request_files.unable_to_delete') }, status: :unprocessable_entity
    end
  end

  private

  def find_exam_request
    @exam = current_business.exams.find(params[:exam_id])
    @exam_request = @exam.exam_requests.find(params[:exam_request_id])
  end

  def document_params
    params.permit(:file)
  end
end
