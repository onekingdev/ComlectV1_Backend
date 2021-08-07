# frozen_string_literal: true

class Api::ExamsController < ApiController
  before_action :find_exam, only: %i[email show]
  before_action :find_auditor, only: %i[email show]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def email
    if @auditor.present?
      @auditor.update(otp: rand.to_s[2..7], otp_requested: Time.zone.now, retries: 0)
      ExamAuditorMailer.otp(@auditor).deliver
      render json: { status: 'ok' }, status: :ok
    else
      respond_with error: I18n.t('api.exams.wrong_auditor_email'), status: :unprocessable_entity
    end
  end

  def show
    return respond_with error: I18n.t('api.exams.wrong_auditor_email'), status: :unprocessable_entity if @auditor.nil?
    @auditor.update(retries: @auditor.retries + 1)
    if @auditor.retries < 4 && @auditor.otp == params[:otp]
      if @auditor.otp_requested > Time.zone.now - 5.minutes
        respond_with @exam, serializer: Public::ExamSerializer
      else
        respond_with error: I18n.t('api.exams.otp_timeout'), status: :unprocessable_entity
      end
    else
      respond_with error: I18n.t('api.exams.too_many_fails'), status: :unprocessable_entity
    end
  end

  private

  def find_exam
    @exam = Exam.find_by(share_uuid: params[:uuid])
  end

  def find_auditor
    @auditor = @exam.exam_auditors.find_by(email: params[:email])
  end
end
