# frozen_string_literal: true
class Charge::Processing
  attr_reader :charge

  def self.process_scheduled!
    Charge.scheduled.where('process_after <= ?', Time.zone.now).find_each do |charge|
      new(charge).process!
    end
  end

  def initialize(charge)
    @charge = charge
  end

  def process!
    # TODO
    charge.processed!
  end
end
