# frozen_string_literal: true
class Business::FavoritesController < FavoritesController
  before_action :require_business!

  def toggle
    @favorite = Favorite.toggle!(current_business, favorite_params)
    super
  end
end
