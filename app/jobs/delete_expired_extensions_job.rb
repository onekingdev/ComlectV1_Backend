# frozen_string_literal: true
class DeleteExpiredExtensionsJob < ActiveJob::Base
  queue_as :default

  def perform(extension_id = nil)
    return process_all if extension_id.nil?
    extension = ProjectExtension.expired.includes(:project).find_by(id: extension_id)
    return if extension.nil?
    ProjectExtension::Request.confirm_or_deny!(project, deny: true)
  end

  private

  def process_all
    ProjectExtension.includes(:project).expired.each do |extension|
      self.class.perform_later extension.id
    end
  end
end
