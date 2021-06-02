# frozen_string_literal: true

class Api::Specialist::FavoritesController < ApiController
  before_action :require_specialist!

  def index
    respond_with current_specialist.favorited_projects.all
  end

  def update
    @local_project = LocalProject.find_by id: favorite_params[:favorited_id]
    if @local_project && favorite_params[:favorited_type] == "Project"
      if Favorite.toggle!(current_specialist, favorite_params)
        respond_with project_id: @local_project.id, toggled: true, status: :ok
      else
        respond_with project_id: @local_project.id, toggled: false, status: :ok
      end
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favorited_type, :favorited_id)
  end
end
