# frozen_string_literal: true

class Api::Specialist::FavoritesController < ApiController
  before_action :require_specialist!

  def index
    respond_with current_specialist.favorited_projects.all.collect(&:id)
  end

  def update
    local_project = LocalProject.find_by id: favorite_params[:favorited_id]
    if local_project && favorite_params[:favorited_type] == "Project"
      Favorite.toggle!(current_specialist, favorite_params)
      respond_with project_id: favorite_params[:favorited_id], status: :ok
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favorited_type, :favorited_id)
  end
end
