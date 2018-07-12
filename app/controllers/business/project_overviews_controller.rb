# frozen_string_literal: true

class Business::ProjectOverviewsController < ApplicationController
  before_action :require_business!
  before_action :find_project

  def show
    respond_to do |format|
      format.html do
        Project::Decorator.decorate(@project).tap do |project|
          render partial: 'projects/dashboards/project_overview', locals: { project: project }
        end
      end
    end
  end

  private

  def find_project
    @project = current_business.projects.find(params[:project_id])
  end
end
