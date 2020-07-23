# frozen_string_literal: true

class Business::FavoritesController < FavoritesController
  before_action :require_business!
end
