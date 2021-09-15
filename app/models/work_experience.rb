# frozen_string_literal: true

class WorkExperience < ApplicationRecord
  belongs_to :specialist

  scope :compliance, -> { where(compliance: true) }

  validates :company, :job_title, presence: true
  validate :dates

  def years
    start_date ? (((end_date || Time.zone.today) - start_date) / 365).to_f : 0
  end

  private

  def dates
    return if start_date.nil? && end_date.nil?
    return if start_date.present? && current

    return errors.add :end_date, :invalid if start_date && !end_date && !current
    return errors.add :start_date, :invalid if start_date.nil? && end_date.present?
    return errors.add :start_date, :invalid if start_date > end_date
  end
end
