# frozen_string_literal: true
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def show
    notification = current_user.notifications.find(params[:id])
    notification.touch :read_at
    respond_to do |format|
      format.html { redirect_to notification.action_path } # "Open Link in New Tab"
      format.js { js_redirect notification.action_path }
    end
  end

  def index
    current_user.notifications.unread.each { |n| n.touch :read_at }
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end
end
