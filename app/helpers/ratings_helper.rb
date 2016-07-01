# frozen_string_literal: true
module RatingsHelper
  def render_stars(rating, options = {})
    css_class = options.delete(:class)
    content_tag :div, class: "stars #{css_class}" do
      Array.new(5).each_with_index.map do |_i, n|
        content_tag :div, '', class: "star #{'active' if n < rating}"
      end.join("\n").html_safe
    end
  end
end
