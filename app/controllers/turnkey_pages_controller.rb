# frozen_string_literal: true

class TurnkeyPagesController < ApplicationController
  def index
    @categories = TurnkeyPage.all.order(:id)
  end

  def show
    @turnkey = TurnkeyPage.find_by(url: params[:id])
  end
end
