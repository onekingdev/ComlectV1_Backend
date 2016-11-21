# frozen_string_literal: true
class ExpireProjectsJob < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.find_by(id: project_id)
    return unless project&.expired?
    Project::Expire.(project)
  end

  private

  def process_all
    Project.expired.each do |project|
      self.class.perform_later project.id
    end
  end
end
