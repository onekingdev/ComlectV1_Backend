# index show

# frozen_string_literal: true

class Api::Business::JobApplicationsController < ApiController
  before_action :require_business!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    @project = current_business.projects.preload_association.find_by(id: params[:project_id])
    return render_404 unless @project
    render json: applications_list, each_serializer: Business::JobApplicationSerializer
  end

  def shortlist
    @job_application = current_business.job_applications.find(params[:job_application_id])
    @job_application.shortlisted? ? @job_application.undecided! : @job_application.shortlisted!
  end

  def hide
    @job_application = current_business.job_applications.find(params[:job_application_id])
    @job_application.hidden? ? @job_application.undecided! : @job_application.hidden!
  end

  private

  def applications_list
    scope = sort_applications(@project.job_applications.preload_association)
    case params[:filter]
    when 'shortlisted'
      scope.shortlisted
    when 'hidden'
      scope.hidden
    else
      scope.undecided
    end
  end

  def sort_applications(scope)
    case params[:sort_by]
    when 'experience'
      scope.order_by_experience
    when 'newest'
      scope.order(created_at: :desc)
    else
      scope.order_by_rating
    end
  end

  def search_params
    params.slice :sort_by
  end
end
