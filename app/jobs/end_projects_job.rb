# frozen_string_literal: true
class EndProjectsJob < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.ending.find_by(id: project_id)
    Project::Ending.process! project if project
  end

  private

  def process_all
    Project.ending.pluck(:id).each do |project_id|
      self.class.perform_later project_id
    end
  end
end
