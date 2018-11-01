# frozen_string_literal: true

class ReferralsController < ApplicationController
  def show
    cookies[:referral] = params[:token]
    redirect_to root_path
  end
end
