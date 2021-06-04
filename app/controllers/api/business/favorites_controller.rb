# frozen_string_literal: true

class Api::Business::FavoritesController < ApiController
  before_action :require_business!
  skip_before_action :verify_authenticity_token

  def index
    respond_with current_business.favorited_specialists, each_serializer: Business::SpecialistSerializer
  end

  def update
    specialist = Specialist.find_by id: favorite_params[:favorited_id]
    if specialist && favorite_params[:favorited_type] == 'Specialist'
      result = Favorite.toggle!(current_business, favorite_params)
      respond_with specialist_id: favorite_params[:favorited_id], favorited: result, status: :ok
    else
      respond_with status: :unprocessable_entity
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favorited_type, :favorited_id)
  end
end
