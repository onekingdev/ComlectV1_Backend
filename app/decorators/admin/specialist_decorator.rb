# frozen_string_literal: true
class Admin::SpecialistDecorator < AdminDecorator
  decorates Specialist

  # rubocop:disable Metrics/AbcSize
  def full_address
    address = []
    address.push [address_1, address_2].map(&:presence).compact
    address.push [city, state, zipcode].map(&:presence).compact
    address.push [country.presence].compact
    address.map { |parts| parts.join(' ').presence }.compact.join('<br/>').html_safe
  end
  # rubocop:enable Metrics/AbcSize
end
