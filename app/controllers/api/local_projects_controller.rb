# frozen_string_literal: true

class Api::LocalProjectsController < ApiController
  before_action :require_someone!
  # before_action :authorize_action
  before_action :find_project, only: %i[show update destroy complete]
  before_action :ongoing_contracts, only: %i[destroy complete]
  before_action :find_project2, only: %i[add_specialist remove_specialist toggle_business]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    projects = if @current_someone.class.name.include?('Business')
      @current_someone.local_projects.where(business_is_collaborator: true).or(@current_someone.local_projects.where(owner: @current_someone)).includes(projects: %i[industries skills jurisdictions end_request extension timesheets])
    else
      @current_someone.local_projects.includes(projects: %i[industries skills jurisdictions end_request extension timesheets])
    end
    respond_with projects, each_serializer: LocalProjectSerializer
  end

  def show
    respond_with @local_project, serializer: LocalProjectWRemindersSerializer
  end

  def create
    if @current_someone.class.name.include?('Specialist')
      render(
        json: { error: t('.mistmusch') },
        status: :unprocessable_entity
      ) and return
    end

    local_project = @current_someone.local_projects.build(local_project_params)
    local_project.business_id = @current_someone.id
    local_project.owner = current_user.specialist || local_project.business
    if local_project.save
      LocalProjectsSpecialist.create(local_project_id: local_project.id, specialist_id: current_user.specialist.id) if current_user.specialist
      process_hide(local_project)
      render json: local_project, status: :created
    else
      respond_with local_project
    end
  end

  def update
    if @local_project.update(local_project_params)
      process_hide(@local_project)
      respond_with @local_project, serializer: LocalProjectSerializer
    else
      render json: @local_project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @ongoing_contracts.count.positive?
      respond_with @ongoing_contracts, each_serializer: ProjectSerializer, status: :unprocessable_entity
    else
      @local_project.destroy
      respond_with @local_project, status: :ok
    end
  end

  def complete
    if @ongoing_contracts.count.positive?
      respond_with @ongoing_contracts, each_serializer: ProjectSerializer, status: :unprocessable_entity
    else
      @local_project.update(status: 'complete')
      respond_with @local_project, status: :ok
    end
  end

  def add_specialist
    lps = LocalProjectsSpecialist.new(local_project_id: @local_project.id, specialist_id: params[:id])
    if lps.save
      Notification::Deliver.got_assigned_for_team_member!(@local_project, lps.specialist)
      respond_with lps
    else
      respond_with errors: { local_projects_specialist: lps.errors.messages }
    end
  end

  def remove_specialist
    lps = LocalProjectsSpecialist.find_by(local_project_id: @local_project.id, specialist_id: params[:specialist_id])
    if lps.present? && lps.destroy
      Notification::Deliver.remove_assigned_for_team_member!(@local_project, lps.specialist)
      respond_with status: :ok
    else
      respond_with errors: { local_projects_specialist: 'Unable to remove collaborator' }
    end
  end

  def toggle_business
    if @local_project.update_attribute('business_is_collaborator', !@local_project.business_is_collaborator)
      respond_with @local_project, serializer: LocalProjectSerializer
    else
      respond_with errors: { local_project: 'Unable to remove business from collaborators' }
    end
  end

  private

  def find_project2
    @local_project = @current_someone.local_projects.find(params[:project_id])
  end

  def find_project
    @local_project = @current_someone.local_projects.find(params[:id])
  end

  def process_hide(lproject)
    return unless local_project_params.to_h.key?(:hide_on_calendar)
    if local_project_params[:hide_on_calendar] == true
      current_user.hide_local_project(lproject.id)
    elsif local_project_params[:hide_on_calendar] == false
      current_user.show_local_project(lproject.id)
    end
  end

  def ongoing_contracts
    @ongoing_contracts = @local_project.projects.where(status: 'published').where.not(specialist_id: nil)
  end

  def local_project_params
    params.require(:local_project).permit(
      :title,
      :description,
      :starts_on,
      :status,
      :ends_on,
      :hide_on_calendar
    )
  end
end
