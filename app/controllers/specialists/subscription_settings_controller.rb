class Specialists::SubscriptionSettingsController < ApplicationController
  # frozen_string_literal: true

  before_action :require_specialist!
  before_action :set_specialist_sub

  def index
    @subscriptions = current_specialist&.ported_subscriptions&.order(id: :asc)
  end

  def update
    render :index
  end

  private

  def set_specialist_sub
    @specialist = current_specialist
  end
end
