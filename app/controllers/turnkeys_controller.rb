# frozen_string_literal: true

class TurnkeysController < ApplicationController
  PAGES = TurnkeyPage.all.collect(&:url).freeze

  def index
    @categories = TurnkeyPage.all.order(:id)
  end

  def page
    return render_404 unless PAGES.include?(params[:page])
    render params[:page]
  end
end
