# frozen_string_literal: true

class Specialists::PortedBusinessesController < ApplicationController
  def index; end

  def buy; end

  def new
    @ported_business = PortedBusiness.new
  end
end
