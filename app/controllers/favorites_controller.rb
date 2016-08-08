# frozen_string_literal: true
class FavoritesController < ApplicationController
  def toggle
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favorited_type, :favorited_id)
  end
end
