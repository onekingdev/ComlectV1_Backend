# frozen_string_literal: true
class AutoAcceptEndRequestsJob < ActiveJob::Base
  queue_as :default

  def perform(end_id = nil)
    return process_all if end_id.nil?
    end_request = ProjectEnd.expired.includes(:project).find_by(id: end_id)
    return if end_request.nil?
    ProjectEnd::Request.confirm_or_deny!(project, confirm: true)
  end

  private

  def process_all
    ProjectEnd.includes(:project).expired.each do |extension|
      next if extension.project.escalated?
      self.class.perform_later extension.id
    end
  end
end
