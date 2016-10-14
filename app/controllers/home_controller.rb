# frozen_string_literal: true
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :beta_protection, if: -> { params[:page] == 'letsencrypt' }

  # TODO: Remove letsencrypt after puchasing SSL cert (also remove letsencrypt.html.erb page)
  layout -> {
    params[:page] == 'letsencrypt' ? false : 'application'
  }

  PAGES = %w(how-it-works about-us terms-of-use privacy-policy partner-network letsencrypt).freeze

  def page
    return render_404 unless PAGES.include?(params[:page])
    render params[:page]
  end

  def app_config
    respond_to do |format|
      format.js
    end
  end
end
