# frozen_string_literal: true
class Notification::Deliver < Draper::Decorator
  decorates Notification

  class << self
    def got_hired!(application)
      dispatcher = Dispatcher.new(application.specialist.user)
      dispatcher.deliver_notification! :got_hired, h.project_dashboard_path(application.project), application.project
      dispatcher.deliver_email! HireMailer, :hired, application
    end
  end

  class Dispatcher
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def deliver_notification!(key, path, associated, message_args = {})
      message = I18n.t(key, message_args.merge(scope: 'notification_messages'))
      user.notifications.fetch(key, associated).delete_all # Re-create existing notification if necessary
      user.notifications.create! key: key, message: message, path: path, associated: associated
    end

    def deliver_email!(mailer, method, *args)
      mailer.deliver_later method, *args
    end
  end
end
