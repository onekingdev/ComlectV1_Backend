# frozen_string_literal: true

class Api::Specialist::JobApplicationsController < ApiController
  before_action :require_specialist!
  before_action :find_project

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def show
    render json: current_specialist.job_applications.find(params[:id])
  end

  def update
    job_application = JobApplication::Form.where(specialist_id: current_specialist.id, id: params[:id]).first
    if @project.rfp? && job_application.update(job_application_params)
      render json: job_application, status: :created
    else
      render json: job_application.errors, status: :unprocessable_entity
    end
  end

  def create
    job_application = JobApplication::Form.apply!(
      current_specialist,
      @project,
      job_application_params
    )
    if job_application.persisted?
      render json: job_application, status: :created
    else
      render json: job_application.errors, status: :unprocessable_entity
    end
  end

  def destroy
    job_application = current_specialist.job_applications.find_by(id: params[:id])
    return render_404 unless job_application
    authorize job_application, :destroy?
    JobApplication::Delete.call(job_application)
    render json: @project
  end

  private

  def job_application_params
    params.permit(
      :message,
      :document,
      :key_deliverables,
      :pricing_type,
      :starts_on,
      :ends_on,
      :hourly_payment_schedule,
      :fixed_payment_schedule,
      :hourly_rate,
      :fixed_budget,
      :estimated_hours,
      :status,
      :fixed_budget,
      :role_details
    )
  end

  def find_project
    @project = Project.published.pending.find(params[:project_id])
  end
end
