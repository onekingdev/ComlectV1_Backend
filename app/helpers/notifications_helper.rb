# frozen_string_literal: true
module NotificationsHelper
  def notification_enabled?(who, notification)
    return false unless Notification.enabled?(who, notification)
    block_given? ? yield : true
  end
end
