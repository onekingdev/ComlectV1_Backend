# frozen_string_literal: true
class EndsIn24Job < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.find_by(id: project_id)
    Project::Ending.ends_in_24! project
  end

  private

  def process_all
    Project.ends_in_24.each do |project|
      self.class.perform_later project.id
    end
  end
end
