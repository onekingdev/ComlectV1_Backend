# frozen_string_literal: true

class Api::Business::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
  before_action :build_project, only: %i[create]

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  FILTERS = {
    'active'   => :active,
    'pending'  => :pending,
    'drafts'   => :draft_and_in_review,
    'complete' => :complete
  }.freeze

  def index
    # filter   = FILTERS[params[:filter]] || :none
    # projects = Project.cards_for_user(current_user, filter: filter)
    # projects.each do |project|
    #   project.populate_rfp(project.job_application) if project.rfp? && project.active?
    # end
    render json: {
      projects: (current_business.projects + current_business.local_projects).sort_by { |i| [i.ends_on ? 0 : 1, i.ends_on] }
    }
  end

  def create
    if policy(@project).post?
      @project.post!
      @project.new_project_notification
      render json: @project, status: :created
    else
      render json: {
        errors: project.errors, alert: I18n.t('activerecord.errors.models.project.attributes.base.no_payment')
      }, status: :unprocessable_entity
    end
  end

  private

  def build_project
    @project = Project::Form.new(business: current_user.business).tap do |project|
      project.assign_attributes project_params
    end
  end

  def project_params
    return { invite_id: params[:invite_id] } unless params.key?(:project)

    params.permit(
      :title,
      :type,
      :location_type,
      :location,
      :lat,
      :lng,
      :description,
      :key_deliverables,
      :duration_type,
      :estimated_days,
      :starts_on,
      :full_time_starts_on,
      :ends_on,
      :applicant_selection,
      :pricing_type,
      :hourly_payment_schedule,
      :fixed_payment_schedule,
      :hourly_rate,
      :fixed_budget,
      :estimated_hours,
      :minimum_experience,
      :only_regulators,
      :status,
      :annual_salary,
      :fee_type,
      :invite_id,
      :est_budget,
      :color,
      :specialist_id,
      :rfp_timing,
      jurisdiction_ids: [],
      industry_ids: [],
      skill_names: []
    )
  end
end
