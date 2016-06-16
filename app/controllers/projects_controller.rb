# frozen_string_literal: true
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!, only: %i(new create edit update)
  before_action :set_project, only: %i(edit update destroy)
  before_action :build_project, only: %i(new create)

  def show
    @project = policy_scope(Project)
               .includes(:industries, :jurisdictions, :skills, business: %i(industries jurisdictions))
               .find(params[:id])
  end

  def create
    respond_to do |format|
      if @project.save
        redirect_path = @project.review? ? url_for(@project) : business_dashboard_path
        format.html { redirect_to redirect_path }
        format.js { js_redirect url_for(redirect_path) }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update_attributes(project_params)
        redirect_path = @project.review? ? url_for(@project) : business_dashboard_path
        format.html { redirect_to redirect_path }
        format.js { js_redirect url_for(redirect_path) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @project.destroy
    redirect_to business_dashboard_path, notice: 'Project deleted'
  end

  private

  def set_project
    @project = policy_scope(Project).includes(:business).find(params[:id])
  end

  def build_project
    @project = current_user.business.projects.new(params[:project] ? project_params : {})
  end

  def project_params
    params.require(:project).permit(
      *%i(title type location_type location description key_deliverables starts_on full_time_starts_on
          ends_on pricing_type hourly_payment_schedule fixed_payment_schedule hourly_rate fixed_budget estimated_hours
          minimum_experience only_regulators status annual_salary fee_type),
      jurisdiction_ids: [], industry_ids: [], skill_ids: []
    )
  end
end
