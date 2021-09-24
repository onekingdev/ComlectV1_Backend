# frozen_string_literal: true

class Api::NotificationsController < ApiController
  before_action :require_someone!

  def index
    notifications = params[:unread].present? ? @current_someone.user.notifications.unread : @current_someone.user.notifications
    respond_with notifications.page(params[:page]).per(50), each_serializer: NotificationSerializer
  end

  def show
    notification = @current_someone.user.notifications.find(params[:id])
    notification.touch :read_at
    respond_with notification, serializer: NotificationSerializer
  end

  def read_all
    @current_someone.user.notifications.unread.touch_all(:read_at)
    respond_with @current_someone.user.notifications.unread, each_serializer: NotificationSerializer
  end
end
