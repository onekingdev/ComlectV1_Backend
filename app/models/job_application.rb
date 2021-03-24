# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :specialist, optional: true
  belongs_to :project, counter_cache: true
  has_one :user, through: :specialist

  enum visibility: { undecided: nil, shortlisted: 'shortlisted', hidden: 'hidden' }

  enum status: {
    draft: 'draft',
    published: 'published',
    accepted: 'accepted'
  }

  scope :preload_association, -> { preload(specialist: :user) }
  scope :by, ->(specialist) { where(specialist_id: specialist) }
  scope :order_by_experience, -> { order('years_of_experience DESC') }
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

  def timing
    if starts_on.present? && ends_on.present?
      bus_starts_on = starts_on.in_time_zone(project.business.tz)
      bus_ends_on = ends_on.in_time_zone(project.business.tz)
      return "#{bus_starts_on.strftime('%b')} #{bus_starts_on.day}-#{bus_ends_on.day}" if starts_on.month == ends_on.month
      "#{bus_starts_on.strftime('%b %d')}-#{bus_ends_on.strftime('%b %d')}"
    elsif estimated_days.present?
      "#{estimated_days} days"
    end
  end

  def dollars
    if pricing_type == 'hourly'
      hourly_rate
    elsif pricing_type == 'fixed'
      fixed_budget
    end
  end

  def hourly_rate?
    pricing_type == 'hourly'
  end
end
