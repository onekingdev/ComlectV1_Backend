# frozen_string_literal: true
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def show
    notification = user.notifications.find(params[:id])
    js_redirect notification.path
  end
end
