# frozen_string_literal: true

class ForumSubscriptionsController < ApplicationController
  # Dumb subscription updater
  before_action :authenticate_user!

  def create
    referer = URI(request.referer).path
    puts "these are params:"
    puts "these are params:"
    puts "these are params:"
    puts "these are params:"
    puts "these are params:"
    puts "these are params:"
    puts "these are params:"
    puts params
    lvl = params[:lvl].to_i
    billing_type = params[:billing_type].to_i
    if [1, 2].include? lvl
      if current_business && current_business.payment_sources.any?
        # current_business.update(qna_lvl: lvl)
        # Monthly/Annual not built on front end yet
        # Go to front end and better optimize params for passage here
        ForumSubscription.create(:business => current_business, :level => lvl, :billing_type => billing_type )
        redirect_to referer, notice: 'Subscription confirmed'
      else
        redirect_to referer, notice: 'Please submit a payment option to proceed'
      end
    else
      redirect_to referer, notice: 'Incorrect options'
    end
  end

  def update

  end

end
