# frozen_string_literal: true

class GenerateReferralTokensJob < ApplicationJob
  queue_as :default

  def perform(specialist_id = nil)
    return process_all if specialist_id.nil?
    specialist = Specialist.find(specialist_id)
    ReferralToken::Generate.new(referrer: specialist, amount_in_cents: 10 * 100).call
  end

  private

  def process_all
    Specialist.all.pluck(:id).each do |specialist_id|
      self.class.perform_later specialist_id
    end
  end
end
