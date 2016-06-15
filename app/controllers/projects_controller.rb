# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!, only: %i(new create edit update)

  def new
    @project = current_user.business.projects.new
  end

  def create
    @project = current_user.business.projects.new(project_params)
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(
      %i(title type location_type location industry_ids description jurisdiction_ids key_deliverables starts_on
         ends_on pricing_type hourly_payment_schedule fixed_payment_schedule hourly_rate fixed_budget estimated_hours
         minimum_experience only_regulators status)
    )
  end
end
