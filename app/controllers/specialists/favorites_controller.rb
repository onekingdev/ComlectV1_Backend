# frozen_string_literal: true
class Specialists::FavoritesController < FavoritesController
  before_action :require_specialist!

  def toggle
    @favorite = Favorite.toggle!(current_specialist, favorite_params)
    super
  end
end
