# frozen_string_literal: true

class Admin::SpecialistDecorator < AdminDecorator
  decorates Specialist

  def full_address
    address = []
    address.push [address_1, address_2].map(&:presence).compact
    address.push [city, state, zipcode].map(&:presence).compact
    address.push [country.presence].compact
    address.map { |parts| parts.join(' ').presence }.compact.join('<br/>').html_safe
  end

  # def years_of_experience
  #   return @_years_of_experience if @_years_of_experience
  #   @_years_of_experience = model[:years_of_experience] || (calculate_years_of_experience / 365.0).round
  # end

  # private

  # def calculate_years_of_experience
  #   work_experiences.compliance.map do |exp|
  #     exp.from ? ((exp.to || Time.zone.today) - exp.from).to_f : 0.0
  #   end.reduce(:+) || 0.0
  # end
end
