# frozen_string_literal: true

class Api::NotificationsController < ApiController
  before_action :require_someone!
  before_action :filter_mirror

  def index
    notifications = params[:unread].present? ? @sender.user.notifications.unread : @sender.user.notifications
    respond_with notifications.page(params[:page]).per(50), each_serializer: NotificationSerializer
  end

  def show
    notification = @sender.user.notifications.find(params[:id])
    notification.touch :read_at
    respond_with notification, serializer: NotificationSerializer
  end

  def read_all
    @sender.user.notifications.unread.touch_all(:read_at)
    respond_with @sender.user.notifications.unread, each_serializer: NotificationSerializer
  end
end
