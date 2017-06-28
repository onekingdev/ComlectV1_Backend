# frozen_string_literal: true

class EndProjectsJob < ApplicationJob
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.find_by(id: project_id)
    return if !project&.ending? || project.escalated? || project.submitted_timesheets? || project.disputed_timesheets?
    Project::Ending.process! project
  end

  private

  def process_all
    Project.ending.each do |project|
      next if project.escalated? || project.submitted_timesheets? || project.disputed_timesheets?
      self.class.perform_later project.id
    end
  end
end
