# frozen_string_literal: true

class Api::Business::ExamsController < ApiController
  before_action :require_business!
  before_action { authorize_action(Roles::ExamsPolicy) }
  before_action { authorize_business_tier(Business::ExamsPolicy) }
  before_action :find_exam, only: %i[update destroy show invite uninvite]

  def index
    respond_with current_business.exams, each_serializer: ExamSerializer
  end

  def show
    respond_with @exam, serializer: ExamSerializer
  end

  def create
    exam = current_business.exams.create(exam_params.merge(share_uuid: SecureRandom.uuid))
    if exam.errors.any?
      respond_with errors: exam.errors, status: :unprocessable_entity
    else
      respond_with exam, serializer: ExamSerializer
    end
  end

  def invite
    auditor = @exam.exam_auditors.create(email: params[:email]) if @exam.exam_auditors.where(email: params[:email]).count.zero?
    if auditor.persisted?
      ExamAuditorMailer.invite_auditor(@exam, auditor, current_business).deliver
      respond_with auditor, serializer: ExamAuditorSerializer
    else
      respond_with errors: auditor.errors, status: :unprocessable_entity
    end
  end

  def uninvite
    auditor = @exam.exam_auditors.find_by(email: params[:email])
    if auditor.present?
      auditor.destroy
      render json: { status: 'ok' }, status: :ok
    else
      respond_with error: I18n.t('api.business.exams.auditor_not_found'), status: :unprocessable_entity
    end
  end

  def update
    if @exam.update(exam_params)
      respond_with @exam, serializer: ExamSerializer
    else
      respond_with errors: @exam.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @exam.destroy
      respond_with @exam, serializer: ExamSerializer
    else
      respond_with errors: @exam.errors, status: :unprocessable_entity
    end
  end

  private

  def find_exam
    @exam = current_business.exams.find(params[:id])
  end

  def exam_params
    params.require(:exam).permit(
      :id, :name, :starts_on, :ends_on, :complete,
      exam_requests_attributes: [:id, :name, :details, :complete, :shared, exam_request_file_ids: [], text_items: []]
    )
  end
end
