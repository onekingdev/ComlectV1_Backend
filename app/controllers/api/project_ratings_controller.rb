# frozen_string_literal: true

class Api::ProjectRatingsController < ApiController
  before_action :require_someone!

  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def index
    ratings = @current_someone.ratings_received.preload_association
    respond_with paginate(ratings), each_serializer: RatingSerializer
  end

  def create
    project = if @current_someone.class.name.include?('Specialist')
      @current_someone.projects.pending_specialist_rating.find(params[:project_id])
    elsif @current_someone.class.name.include?('Business')
      @current_someone.projects.pending_business_rating.find(params[:project_id])
    end

    rating = project.ratings.new(rating_params.merge(rater: @current_someone))
    if rating.save
      Notification::Deliver.got_rated! rating
      respond_with rating, serializer: RatingSerializer
    else
      respond_with rating.errors.to_json, status: unprocessable_entity
    end
  end

  private

  def rating_params
    params.permit(:value, :review)
  end
end
