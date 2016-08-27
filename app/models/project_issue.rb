# frozen_string_literal: true
class ProjectIssue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :issue, :desired_resolution, presence: true
end
