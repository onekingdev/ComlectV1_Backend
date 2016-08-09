# frozen_string_literal: true
class WorkExperience < ActiveRecord::Base
  belongs_to :specialist

  scope :compliance, -> { where(compliance: true) }

  validate :validate_from_to

  private

  def validate_from_to
    return if from.nil? || to.nil?
    errors.add :from, :invalid if from > to
  end
end
