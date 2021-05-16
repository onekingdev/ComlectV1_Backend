# frozen_string_literal: true

class Api::Business::ExamRequestsController < ApiController
  before_action :require_business!
  before_action :find_exam, only: %i[create update destroy]
  before_action :find_exam_request, only: %i[update destroy]

  def create
    exam_request = @exam.exam_requests.create(exam_request_params)
    if exam_request.errors.any?
      respond_with errors: exam_request.errors, status: :unprocessable_entity
    else
      respond_with exam_request, serializer: ExamRequestSerializer
    end
  end

  def update
    if @exam_request.update(exam_request_params)
      respond_with @exam_request, serializer: ExamRequestSerializer
    else
      respond_with errors: @exam_request.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @exam_request.destroy
      respond_with @exam_request, serializer: ExamRequestSerializer
    else
      respond_with errors: @exam_request.errors, status: :unprocessable_entity
    end
  end

  private

  def find_exam
    @exam = current_business.exams.find(params[:exam_id])
  end

  def find_exam_request
    @exam_request = @exam.exam_requests.find(params[:id])
  end

  def exam_request_params
    params.permit(
      :name, :details, :text_items, :complete, :shared, exam_request_file_ids: []
    )
  end
end
