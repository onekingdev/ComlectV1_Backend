# frozen_string_literal: true
class Business::JobApplicationsController < ApplicationController
  before_action :require_business!

  def index
    @project = current_business.projects.preload_associations.find(params[:project_id])
    respond_to do |format|
      format.html do
        if request.xhr?
          @job_applications = applications_list
          render partial: 'cards', locals: { job_applications: @job_applications }
        end
      end
    end
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
    scope = sort_applications(@project.job_applications.preload_associations)
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
      scope # TODO: Sort by rating
    end
  end

  def search_params
    params.slice :sort_by
  end
end
