# frozen_string_literal: true
class WorkExperience::Decorator < ApplicationDecorator
  decorates WorkExperience
  delegate_all

  def month_year_span
    return nil if !current && model.to.nil?
    to = current? ? 'Current' : model.to.strftime('%b %Y')
    "#{from.strftime('%b %Y')} to #{to}"
  end

  def years
    return 0 if from.nil? || (to.nil? && !current?)
    days = current? ? (Time.zone.now.to_date - from).to_i : (to - from).to_i
    days / 365 # TODO: Round?
  end
end
