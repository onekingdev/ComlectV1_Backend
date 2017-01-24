# frozen_string_literal: true
class ProjectIssue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :admin_user

  enum status: { open: 'open', closed: 'closed' }

  validates :issue, presence: true
end
