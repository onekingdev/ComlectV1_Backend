# frozen_string_literal: true

class Api::Business::ExamRequestsController < ApiController
  before_action :require_business!
  before_action :find_exam_request, only: %i[create update]

  def create
    exam = current_business.exams.create(exam_params)
    if exam.errors.any?
      respond_with errors: exam.errors, status: :unprocessable_entity
    else
      respond_with exam, serializer: ExamSerializer
    end
  end

  def update
    if @exam.update(exam_params)
      respond_with @exam, serializer: ExamSerializer
    else
      respond_with errors: @exam.errors, status: :unprocessable_entity
    end
  end

  private

  def find_exam_request
    @exam = current_business.exams.find(params[:exam_id])
    @exam_request = @exam.exam_requests.find(params[:id])
  end

  def exam_params
    params[:exam_request].permit(
      :name, :details, :text_items, :complete, :shared, exam_request_file_ids: []
    )
  end
end
