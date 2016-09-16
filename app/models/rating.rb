# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :project
  belongs_to :rater, polymorphic: true

  scope :by, -> (rater) { where(rater: rater) }
  scope :preload_associations, -> { preload(:project, :rater) }

  attr_accessor :should_update_stats

  after_save -> { self.should_update_stats = value_changed? }
  after_destroy -> { self.should_update_stats = true }
  after_commit :update_stats, if: :should_update_stats

  validates :review, presence: true, if: -> { value.blank? || value < 4 }

  private

  def update_stats
    rater.is_a?(Specialist) ? update_rated(project.business) : update_rated(project.specialist)
  end

  def update_rated(rated)
    count = rated.ratings_received.count
    total = rated.ratings_received.sum(:value)
    rated.ratings_count = count
    rated.ratings_total = total
    rated.ratings_average = count > 0 ? total / (count * 1.0) : nil
    rated.save! validate: false
  end
end
