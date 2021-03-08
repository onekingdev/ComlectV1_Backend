# frozen_string_literal: true

class RatingSerializer < ApplicationSerializer
  attributes :id,
             :project_id,
             :project_title,
             :rater_name,
             :rater_id,
             :rater_type,
             :rater_pic,
             :value,
             :review,
             :created_at

  def project_title
    object.project.title
  end

  def rater_name
    object.rater.name
  end

  def rater_pic
    object.rater.class.name == 'Specialist' ? object.rater.photo_url(:thumb) : object.rater.logo_url(:thumb)
  end
end
