# frozen_string_literal: true
class ExpireProjectsJob < ActiveJob::Base
  queue_as :default

  def perform(project_id = nil)
    return process_all if project_id.nil?
    project = Project.expired.find_by(id: project_id)
    Project::Expire.(project) if project
  end

  private

  def process_all
    Project.expired.each do |project|
      self.class.perform_later project.id
      Notification::Deliver.start_date_lapsed! project
    end
  end
end
