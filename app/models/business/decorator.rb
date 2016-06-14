# frozen_string_literal: true
class Business::Decorator < Draper::Decorator
  decorates Business
  delegate_all

  def state_country
    [state, country].map(&:presence).compact.join(', ')
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
    rating = 4
    h.content_tag :div, class: 'stars' do
      Array.new(5).each_with_index.map do |_i, n|
        h.content_tag :div, '', class: "star #{'active' if n < rating}"
      end.join("\n").html_safe
    end
  end

  private

  def normalize_url(url)
    prefix = url =~ /^https?:\/\// ? nil : 'http://'
    "#{prefix}#{url}"
  end
end
