# frozen_string_literal: true
module NotificationsHelper
  def notification_enabled?(who, notification)
    enabled = who.settings(:notifications).public_send(notification)
    return false unless enabled
    block_given? ? yield : true
  end
end
