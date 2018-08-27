# frozen_string_literal: true

class SyncHubspotContactJob < ApplicationJob
  queue_as :default

  def perform(record)
    HubspotContact.for(record).sync
  end
end
