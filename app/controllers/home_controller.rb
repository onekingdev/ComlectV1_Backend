# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAGES = %w[
    faqs
    terms-of-use
    privacy-policy
    partner-network
    member-partner-network
    about-us
  ].freeze

  def page
    return render_404 unless PAGES.include?(params[:page])
    render params[:page]
  end

  def partnerships
    s = {}
    Partnership.all.order(:id).each do |p|
      c = p.category.to_sym
      s[c] = [] unless s.keys.include? c
      s[c].push(p)
    end
    @partnerships = s
  end

  def press
    @articles = Article.order(published_at: :desc).paginate(page: params[:page])
  end

  def app_config
    respond_to do |format|
      format.js
    end
  end
end
