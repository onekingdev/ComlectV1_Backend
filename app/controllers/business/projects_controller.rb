# frozen_string_literal: true
class Business::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!, only: %i(index new create edit update)
  before_action :set_project, only: %i(edit update destroy post)
  before_action :build_project, only: %i(new create)

  FILTERS = {
    'active'   => :active,
    'pending'  => :pending,
    'drafts'   => :draft_and_in_review,
    'complete' => :complete
  }.freeze

  def index
    @filter    = FILTERS[params[:filter]] || :none
    @projects = Project.cards_for_user(current_user, filter: @filter, page: params[:page], per: params[:per])
    respond_to do |format|
      format.html do
        render partial: 'cards', projects: @projects if request.xhr?
      end
      format.js
    end
  end

  def show
    @project = policy_scope(Project)
               .includes(:industries, :jurisdictions, :skills, business: %i(industries jurisdictions))
               .find(params[:id])
    render template: 'projects/show'
  end

  def create
    respond_to do |format|
      if @project.save
        redirect_path = @project.review? ? business_project_path(@project) : business_dashboard_path
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
        Project::Starting.fix_starting!(@project)
        redirect_path = @project.review? ? business_project_path(@project) : business_dashboard_path
        format.html { redirect_to redirect_path }
        format.js { js_redirect url_for(redirect_path) }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def post
    if policy(@project).post?
      @project.post!
      redirect_to business_dashboard_path
    else
      redirect_to business_project_path(@project),
                  alert: I18n.t('activerecord.errors.models.project.attributes.base.no_payment')
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to business_project_path(@project), alert: @project.errors.full_messages
  end

  def copy
    original = current_user.business.projects.find(params[:id])
    @project = Project::Form.copy(original)
    render :new
  end

  def destroy
    redirect_to business_dashboard_path, notice: 'Project deleted'
  end

  private

  def set_project
    @project = policy_scope(Project::Form).includes(:business).find(params[:id])
  end

  def build_project
    @project = Project::Form.new(business: current_user.business).tap do |project|
      project.assign_attributes project_params
    end
  end

  def project_params
    return { invite_id: params[:invite_id] } unless params.key?(:project)
    params.require(:project).permit(
      *%i(title type location_type location lat lng description key_deliverables starts_on full_time_starts_on
          ends_on pricing_type hourly_payment_schedule fixed_payment_schedule hourly_rate fixed_budget estimated_hours
          minimum_experience only_regulators status annual_salary fee_type invite_id),
      jurisdiction_ids: [], industry_ids: [], skill_names: []
    )
  end
end
