# frozen_string_literal: true
class Timesheet < ActiveRecord::Base
  belongs_to :project
  has_many :time_logs, dependent: :destroy

  scope :sorted, -> { order(created_at: :desc) }

  enum status: { pending: 'pending', submitted: 'submitted', approved: 'approved', disputed: 'disputed' }

  accepts_nested_attributes_for :time_logs, allow_destroy: true

  validates :time_logs, presence: true

  def total_due
    time_logs.sum(:hours) * project.hourly_rate
  end
end
