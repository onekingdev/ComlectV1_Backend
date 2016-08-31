# frozen_string_literal: true
class Rating < ActiveRecord::Base
  belongs_to :project # TODO: counter cache
  belongs_to :rater, polymorphic: true

  scope :by, -> (rater) { where(rater: rater) }

  validates :review, presence: true, if: -> { value.blank? || value < 4 }
end
