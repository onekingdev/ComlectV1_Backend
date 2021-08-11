# frozen_string_literal: true

class Api::Business::HiresController < ApiController
  before_action :require_business!
  before_action :find_project

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    if @project.pending?
      job_application = JobApplication::Accept.call(
        @project.job_applications.find(params.require(:job_application_id))
      )
      specialist = job_application.object.specialist
      specialist.specialists_business_roles.create(
        business_id: job_application.object.project.business.id,
        role: params.require(:role)
      )
      LocalProjectsSpecialist.create(local_project_id: @project.local_project.id, specialist_id: specialist.id)
    end
    render json: job_application, status: (job_application.blank? ? :unprocessable_entity : :created)
  end

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
