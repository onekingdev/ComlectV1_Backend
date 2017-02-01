# frozen_string_literal: true
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def show
    notification = current_user.notifications.find(params[:id])
    notification.touch :read_at
    js_redirect notification.path
  end
end
