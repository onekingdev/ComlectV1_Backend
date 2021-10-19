# frozen_string_literal: true

class Api::SubscriptionsController < ApiController
  before_action :require_someone!

  def index
    subscriptions = @current_someone.subscriptions.ccc.active
    mod = @current_someone.business? ? Business : Specialist
    respond_with subscriptions, each_serializer: mod::SubscriptionSerializer
  end
end
