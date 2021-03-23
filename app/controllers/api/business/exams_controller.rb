# frozen_string_literal: true

class Api::Business::ExamsController < ApiController
  before_action :require_business!
  before_action :find_exam, only: %i[update destroy show]

  def index
    respond_with json: current_business.exams.to_json, each_serializer: ExamSerializer
  end

  def show
    respond_with @exam, serializer: ExamSerializer
  end

  def create
    exam = current_business.exams.create(exam_params)
    if exam.errors.any?
      respond_with errors: exam.errors, status: :unprocessable_entity
    else
      respond_with exam, serializer: ExamSerializer
    end
  end

  private

  def find_exam
    @exam = current_business.exams.find(params[:id])
  end

  def exam_params
    params[:exam].permit(
      :name, :starts_on, :ends_on,
      exam_requests_attributes: %i[name details text_items complete shared exam_request_file_ids]
    )
  end
end
