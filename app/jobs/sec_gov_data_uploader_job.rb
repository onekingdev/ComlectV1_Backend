# frozen_string_literal: true

class SecGovDataUploaderJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform
    PotentialBusinessesImporter.new.call
  end
end
