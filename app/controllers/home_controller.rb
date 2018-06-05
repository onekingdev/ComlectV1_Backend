# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAGES = %w[
    how-it-works
    terms-of-use
    privacy-policy
    partner-network
    member-partner-network
  ].freeze

  def page
    return render_404 unless PAGES.include?(params[:page])
    render params[:page]
  end

  def partnerships
    s = {}; Partnership.all.order(:id).each { |p| c = p.category.to_sym; s[c] = [] if !s.keys.include? c; s[c].push(p) }
    s["Become a partner"]
    @partnerships = s
  end

  def app_config
    respond_to do |format|
      format.js
    end
  end
end
