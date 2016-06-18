# frozen_string_literal: true
class BusinessDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!

  def show
    @business = current_user.business
  end
end
