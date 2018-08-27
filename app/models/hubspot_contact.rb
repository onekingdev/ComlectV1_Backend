# frozen_string_literal: true

class HubspotContact
  attr_reader :object

  def self.for(record)
    case record
    when Specialist
      Specialist::Hubspot.new Specialist::Decorator.decorate(record)
    else
      Business::Hubspot.new Business::Decorator.decorate(record)
    end
  end

  def initialize(object)
    @object = object
  end

  def sync
    return if ENV['HUBSPOT_API_KEY'].blank?
  end
end

require_dependency 'business/hubspot'
require_dependency 'specialist/hubspot'
