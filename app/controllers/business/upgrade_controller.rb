# frozen_string_literal: true

class Business::UpgradeController < ApplicationController
  def index
    @payment_source = current_business.payment_profile.default_payment_source
  end

  def buy; end
end
