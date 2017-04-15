# frozen_string_literal: true
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAGES = %w(how-it-works terms-of-use privacy-policy partner-network).freeze

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
