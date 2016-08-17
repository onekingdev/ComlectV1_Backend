# frozen_string_literal: true
class JobApplication < ActiveRecord::Base
  belongs_to :specialist
  belongs_to :project, counter_cache: true
  has_one :user, through: :specialist

  scope :preload_associations, -> { preload(specialist: :user) }
  scope :by, -> (specialist) { where(specialist_id: specialist) }
  scope :order_by_experience, -> {
    # TODO: Adjust when implementing rounding
    joins(specialist: :work_experiences)
      .select('job_applications.*, SUM((COALESCE("to", NOW())::date - "from"::date) / 365) AS years_of_experience')
      .group(:id)
      .order("years_of_experience DESC")
  }

  validates :message, presence: true
  validates :project_id, uniqueness: { scope: :specialist_id }

  def accept!
    # TODO: Send notification to specialist
    project.update_attribute :specialist_id, specialist_id
  end
end
