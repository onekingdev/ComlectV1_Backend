# frozen_string_literal: true
class WorkExperience::Decorator < ApplicationDecorator
  decorates WorkExperience
  delegate_all

  def month_year_span
    to = current? ? 'Current' : model.to.strftime('%m/%Y')
    "#{from.strftime('%m/%Y')} to #{to}"
  end
end
