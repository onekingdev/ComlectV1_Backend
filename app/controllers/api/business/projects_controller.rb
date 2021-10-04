# frozen_string_literal: true

class Api::Business::ProjectsController < ApiController
  before_action :require_business!
  before_action :build_project, only: %i[create]
  before_action :find_project, only: %i[show update destroy]

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    if project_params[:status] == 'draft'
      @project.save(validate: false)
      @project = build_local_project(@project) unless @project.local_project_id
      respond_with @project, serializer: ProjectSerializer
    elsif policy(@project).post? && @project.validate
      return no_payment_error unless @project.user.payment_info?
      @project.post!
      @project.new_project_notification
      @project = build_local_project(@project) unless @project.local_project_id
      respond_with @project, serializer: ProjectSerializer
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    @project = Project::Form.find(@project.id)
    src_status = @project.status
    if project_params[:status] == 'draft'
      @project.assign_attributes project_params
      @project.save(validate: false)
    elsif @project.update(project_params)
      if project_params[:status] != 'draft' || src_status == 'published'
        return no_payment_error unless @project.user.payment_info?
        @project.post!
      end
      respond_with @project, serializer: ProjectSerializer
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @project.specialist_id.nil? && @project.destroy
      respond_with @project, serializer: ProjectSerializer
    else
      render json: (@project.errors.keys.count.positive? ? @project.errors : { error: I18n.t('api.business.projects.project_has_specialist') }.to_json),
             status: :unprocessable_entity
    end
  end

  def show
    respond_with @project, serializer: ProjectSerializer
  end

  private

  def no_payment_error
    render json: { 'errors': [t('activerecord.errors.models.project.attributes.base.no_payment_alt')] }, status: :unprocessable_entity
  end

  def build_local_project(project)
    local_project_params = project.attributes.slice('business_id', 'title', 'description', 'starts_on', 'ends_on')
    local_project = current_business.local_projects.new
    local_project.assign_attributes(local_project_params)
    local_project.owner = current_user.specialist || local_project.business
    local_project.save!
    LocalProjectsSpecialist.create(local_project_id: local_project.id, specialist_id: current_user.specialist.id) if current_user.specialist
    project.update_attribute('local_project_id', local_project.id)
    project
  end

  def build_project
    @project = Project::Form.new(business: current_business).tap do |project|
      project.assign_attributes project_params
    end
  end

  def project_params
    params.permit(
      :local_project_id,
      :title,
      :type,
      :location_type,
      :location,
      :lat,
      :lng,
      :description,
      :key_deliverables,
      :role_details,
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
      :upper_hourly_rate,
      :fixed_budget,
      :estimated_hours,
      :minimum_experience,
      :only_regulators,
      :annual_salary,
      :fee_type,
      :invite_id,
      :est_budget,
      :status,
      :color,
      :specialist_id,
      jurisdiction_ids: [],
      industry_ids: [],
      skill_names: []
    )
  end

  def find_project
    @project = current_business.projects.find(params[:id])
  end
end
