# frozen_string_literal: true

class TurnkeyPagesController < ApplicationController
  def index
    @categories = TurnkeyPage.all.order(:id)
  end

  def show
    @states = %w[Alabama Alaska Arizona
                 Arkansas California Colorado
                 Connecticut Delaware Florida
                 Georgia Hawaii Idaho Illinois
                 Indiana Iowa Kansas Kentucky
                 Louisiana Maine Maryland Massachusetts
                 Michigan Minnesota Mississippi Missouri
                 Montana Nebraska Nevada New Hampshire
                 New Jersey New Mexico New York
                 North Carolina North Dakota Ohio
                 Oklahoma Oregon Pennsylvania Rhode
                 Island South Carolina South Dakota
                 Tennessee Texas Utah Vermont Virginia
                 Washington West Virginia Wisconsin Wyoming]

    @turnkey_page = TurnkeyPage.find_by(url: params[:id])
  end

  def create
    # puts params[:solution].inspect
  end
end
