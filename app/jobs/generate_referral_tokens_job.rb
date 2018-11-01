# frozen_string_literal: true

class GenerateReferralTokensJob < ApplicationJob
  queue_as :default

  def perform(record = nil)
    return process_all if record.nil?
    ReferralToken::Generate.new(referrer: record, amount_in_cents: 10 * 100).call
  end

  private

  def process_all
    Business.all.each do |business|
      self.class.perform_later business
    end

    Specialist.all.each do |specialist|
      self.class.perform_later specialist
    end
  end
end
