# frozen_string_literal: true
module RatingsHelper
  def render_stars(rating, options = {})
    css_class = options.delete(:class)
    # rounded = (rating || 0).round
    # content_tag :div, class: "stars #{css_class}" do
    #  Array.new(5).each_with_index.map do |_i, n|
    #    content_tag :div, '', class: "star #{'active' if n < rounded}"
    #  end.join("\n").html_safe
    # end
    content_tag(:div, nil, class: "stars_bg #{css_class}") do
      content_tag(:div, nil, class: "stars_fg", style: "width: #{rating * 100.0 / 5}%") if rating
    end
  end

  def rating_average_text(rated)
    return if rated.ratings_average.nil? || rated.ratings_average.zero?
    "#{rated.ratings_average.round(1)} from #{pluralize rated.ratings_count, 'Review', 'Reviews'}"
  end
end
