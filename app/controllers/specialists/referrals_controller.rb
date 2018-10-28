# frozen_string_literal: true

class Specialists::ReferralsController < ApplicationController
  before_action :require_specialist!

  def show
    @specialist = current_specialist
    @credit = Specialist::Credit.for(@specialist)
    @token = @specialist.referral_token
  end
end
