# frozen_string_literal: true
class StartsIn48Job < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.find_by(id: project_id)
    Project::Starting.process! project
  end

  private

  def process_all
    Project.starts_in_48.each do |project|
      self.class.perform_later project.id
    end
  end
end
