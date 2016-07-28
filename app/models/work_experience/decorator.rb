# frozen_string_literal: true
class WorkExperience::Decorator < ApplicationDecorator
  decorates WorkExperience
  delegate_all

  def year_span
    return from.year if from.year == to.year
    "#{from.year}-#{to.year}"
  end
end
