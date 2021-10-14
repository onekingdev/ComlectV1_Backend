# frozen_string_literal: true

class Api::ProjectRatingsController < ApiController
  before_action :require_someone!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    ratings = @current_someone.ratings_received.preload_association
    respond_with paginate(ratings), each_serializer: RatingSerializer
  end

  def create
    project = Project.find(params[:project_id])
    rate = Rating.find_by(project_id: params[:project_id], rater_type: @current_someone.class.to_s)
    rate&.assign_attributes(rating_params)
    rating = rate || project.ratings.new(rating_params.merge(rater: @current_someone))
    if rating.save
      Notification::Deliver.got_rated! rating
      respond_with rating, serializer: RatingSerializer
    else
      respond_with rating.errors.to_json, status: :unprocessable_entity
    end
  end

  private

  def rating_params
    params.permit(:value, :review)
  end
end
