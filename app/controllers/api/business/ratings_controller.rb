# frozen_string_literal: true

class Api::Business::RatingsController < ApiController
  before_action :require_business!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    ratings = current_business.ratings_received.preload_association
    respond_with paginate(ratings), each_serializer: RatingSerializer
  end
end
