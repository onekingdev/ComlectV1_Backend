# frozen_string_literal: true
class Business::Decorator < ApplicationDecorator
  decorates Business
  delegate_all

  def state_country
    [state, country].map(&:presence).compact.join(', ')
  end

  def city_state_country
    [city, state, country].map(&:presence).compact.join(', ')
  end

  def website_short
    URI.parse(website_url).hostname
  end

  def website_url
    normalize_url website
  end

  def linkedin_url
    normalize_url linkedin_link
  end

  def render_stars
    h.render_stars 4
  end
end
