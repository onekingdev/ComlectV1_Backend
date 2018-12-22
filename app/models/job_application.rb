# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :specialist
  belongs_to :project, counter_cache: true
  has_one :user, through: :specialist

  enum visibility: { undecided: nil, shortlisted: 'shortlisted', hidden: 'hidden' }

  enum status: {
    draft: 'draft',
    published: 'published',
    accepted: 'accepted'
  }

  scope :preload_associations, -> { preload(specialist: :user) }
  scope :by, ->(specialist) { where(specialist_id: specialist) }
  scope :order_by_experience, -> {
    # TODO: Adjust when implementing rounding
    joins(specialist: :work_experiences)
      .select('job_applications.*, SUM((COALESCE("to", NOW())::date - "from"::date) / 365) AS years_of_experience')
      .where(work_experiences: { id: WorkExperience.compliance })
      .group(:id)
      .order('years_of_experience DESC')
  }
  scope :order_by_rating, -> {
    joins(:specialist).order('specialists.ratings_average DESC NULLS LAST')
  }
  scope :pending, -> { joins(:project).where(projects: { specialist_id: nil }) }
  scope :not_accepted, -> {
    joins(:project)
      .where.not(projects: { specialist_id: nil })
      .where('projects.specialist_id != job_applications.specialist_id')
  }

  validates :project_id, uniqueness: { scope: :specialist_id }

  delegate :rfp?, to: :project
end
