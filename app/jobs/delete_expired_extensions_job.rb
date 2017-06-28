# frozen_string_literal: true

class DeleteExpiredExtensionsJob < ApplicationJob
  queue_as :default

  def perform(extension_id = nil)
    return process_all if extension_id.nil?
    extension = ProjectExtension.expired.includes(:project).find_by(id: extension_id)
    return if extension.nil?
    ProjectExtension::Request.confirm_or_deny!(extension.project, deny: true)
  end

  private

  def process_all
    ProjectExtension.expired.pluck(:id).each do |extension_id|
      self.class.perform_later extension_id
    end
  end
end
