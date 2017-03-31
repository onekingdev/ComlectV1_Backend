# frozen_string_literal: true
class BusinessDashboardController < ApplicationController
  before_action :require_business!

  def show
    @business = current_user.business
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_associations
  end
end
