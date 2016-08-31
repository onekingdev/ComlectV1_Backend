# frozen_string_literal: true
class Business::Decorator < ApplicationDecorator
  decorates Business
  delegate_all

  def favorited?(favorited)
    @_all_favorited ||= favorites.pluck(:id, :favorited_type, :favorited_id).each_with_object({}) do |attrs, hash|
      hash["#{attrs[1]}/#{attrs[2]}"] = attrs[0]
    end
    @_all_favorited.key?("#{favorited.model_name}/#{favorited.id}")
  end

  def favorited_id(favorited)
    return nil unless favorited?(favorited)
    @_all_favorited["#{favorited.model_name}/#{favorited.id}"]
  end

  def filtered_specialists(filter)
    return Specialist.none if filter == :none
    public_send "#{filter}_specialists"
  end

  def favorited_specialists
    model.favorite_specialists
  end

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
    h.render_stars ratings_average
  end
end
