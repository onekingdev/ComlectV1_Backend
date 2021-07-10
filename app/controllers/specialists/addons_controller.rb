# frozen_string_literal: true

class Specialists::AddonsController < ApplicationController
  def index
    render 'business/addons/index'
  end
end
