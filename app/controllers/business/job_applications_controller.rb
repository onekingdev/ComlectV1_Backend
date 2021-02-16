# frozen_string_literal: true

class Business::JobApplicationsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def index
    @project = current_business.projects.preload_association.find_by(id: params[:project_id])
    @applications = applications_list.to_json(include: { specialist: {} })
    render html: content_tag('applications-index-page', '', ':applications': @applications).html_safe,
           layout: 'vue_business'
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
