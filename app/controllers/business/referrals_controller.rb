# frozen_string_literal: true

class Business::ReferralsController < ApplicationController
  before_action :require_business!

  def show
    @business = current_business
    @credit = Business::Credit.for(@business)
    @token = @business.referral_token
  end
end
