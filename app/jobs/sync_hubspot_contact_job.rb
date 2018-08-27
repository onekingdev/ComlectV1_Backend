# frozen_string_literal: true

class SyncHubspotContactJob < ApplicationJob
  queue_as :default

  def perform(record = nil)
    return process_all if record.nil?
    HubspotContact.for(record).sync
  end

  private

  def process_all
    Business.all.each { |business| self.class.perform_later(business) }
    Specialist.all.each { |specialist| self.class.perform_later(specialist) }
  end
end
