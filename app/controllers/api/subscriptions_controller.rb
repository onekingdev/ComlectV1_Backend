# frozen_string_literal: true

class Api::SubscriptionsController < ApiController
  before_action :require_someone!

  def index
    subscriptions = @current_someone.subscriptions
    respond_with subscriptions, each_serializer: SubscriptionSerializer
  end
end
