# frozen_string_literal: true
class ProjectRatingsController < ApplicationController
  skip_before_action :check_unrated_project
  before_action :find_project, :set_form_url
  protect_from_forgery only: []

  def new
    return render js: '' unless @project
    @rating = @project.ratings.new(rater: specialist_or_business)
  end

  def create
    @rating = @project.ratings.new(rating_params.merge(rater: specialist_or_business))
    if @rating.save
      js_redirect redirect_url
    else
      render :new
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value, :review)
  end
end
