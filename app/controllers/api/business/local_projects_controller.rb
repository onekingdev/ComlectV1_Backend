# frozen_string_literal: true

class Api::Business::LocalProjectsController < ApiController
  before_action :require_business!

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
    render json: { projects: current_business.local_projects }
  end

  def show
    render json: { project: current_business.local_projects.find(params[:id]) }
  end

  def create
    project = LocalProject.new(project_params)
    project.business_id = current_business.id
    project.status = 'active'
    if project.save
      render json: project, status: :created
    else
      render json: project.errors, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:local_project).permit(
      :title,
      :description,
      :starts_on,
      :ends_on
    )
  end
end
