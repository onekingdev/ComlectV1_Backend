# frozen_string_literal: true

class WorkExperience < ApplicationRecord
  belongs_to :specialist

  scope :compliance, -> { where(compliance: true) }

  validates :company, :job_title, presence: true
  validate :validate_from_to

  def years
    from ? (((to || Time.zone.today) - from) / 365).to_f : 0
  end

  private

  def validate_from_to
    return if from.nil? || to.nil?
    errors.add :from, :invalid if from > to
  end
end
