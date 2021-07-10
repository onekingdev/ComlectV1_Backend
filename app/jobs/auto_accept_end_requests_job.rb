# frozen_string_literal: true

class AutoAcceptEndRequestsJob < ApplicationJob
  queue_as :default

  def perform(end_id = nil)
    return process_all if end_id.nil?
    end_request = ProjectEnd.expired.includes(:project).find_by(id: end_id)
    return if end_request.nil?
    ProjectEnd::Request.confirm_or_deny!(end_request.project, confirm: true)
  end

  private

  def process_all
    ProjectEnd.expired.pluck(:id).each do |id|
      self.class.perform_later id
    end
  end
end
