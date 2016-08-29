# frozen_string_literal: true
class ProjectIssue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  enum status: { open: 'open', closed: 'closed' }

  validates :user, :issue, :desired_resolution, presence: true
end
