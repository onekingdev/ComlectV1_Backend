# frozen_string_literal: true

class Business::SubscriptionSettingsController < ApplicationController
  before_action :require_business!
  before_action :set_biz_sub

  def index
    @subscriptions = current_business&.subscriptions&.order(id: :asc)
  end

  def update
    render :index
  end

  private

  def set_biz_sub
    @business = current_business
    @forum_sub = current_business.forum_subscription
    @forum_sub = OpenStruct.new(billing_type: 'annual') if @forum_sub.nil?
  end
end
