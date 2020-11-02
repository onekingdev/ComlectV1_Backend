# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: :q_and_a_forum

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
    @partnerships = {}

    Partnership.all.order(:id).each do |partnership|
      category = partnership.category.to_sym
      @partnerships[category] = [] unless @partnerships.key?(category)
      @partnerships[category].push(partnership)
    end

    @partnerships
  end

  def press
    @articles = Article.order(published_at: :desc)
  end

  def app_config
    respond_to do |format|
      format.js
    end
  end

  def q_and_a_forum
    @forum_sub = current_business.forum_subscription
    @forum_sub = OpenStruct.new(billing_type: 'annual') if @forum_sub.nil?
  end
end
