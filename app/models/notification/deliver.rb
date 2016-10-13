# frozen_string_literal: true
class Notification::Deliver < Draper::Decorator
  decorates Notification

  class << self
    def got_hired!(application)
      dispatcher = Dispatcher.new(application.specialist.user)
      dispatcher.deliver_notification! :got_hired, h.project_dashboard_path(application.project), application.project
      dispatcher.deliver_email! HireMailer, :hired, application
    end

    def not_hired!(application)
      return unless Notification.enabled? application.specialist, :not_hired
      dispatcher = Dispatcher.new(application.specialist.user)
      dispatcher.deliver_notification! :not_hired,
                                       h.projects_path,
                                       application.project,
                                       clear_manually: true,
                                       t: { project_title: application.project.title }
      dispatcher.deliver_email! HireMailer, :not_hired, application
    end

    def got_rated!(rating)
      rating.rater == rating.project.business ? specialist_got_rated!(rating) : business_got_rated!(rating)
    end

    def specialist_got_rated!(rating)
      return unless Notification.enabled?(rating.project.specialist, :got_rated)
      dispatcher.deliver_notification! :specialist_got_rated,
                                       h.specialists_dashboard_path(anchor: 'ratings-reviews'),
                                       rating
      dispatcher.deliver_email! RatingMailer, :notification, rating.id
    end

    def business_got_rated!(rating)
      return unless Notification.enabled?(rating.project.business, :got_rated)
      dispatcher.deliver_notification! :business_got_rated,
                                       h.business_dashboard_path(anchor: 'ratings-reviews'),
                                       rating
      dispatcher.deliver_email! RatingMailer, :notification, rating.id
    end
  end

  class Dispatcher
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def deliver_notification!(key, path, associated, clear_manually: false, t: {})
      message = I18n.t(key, t.merge(scope: 'notification_messages'))
      user.notifications.fetch(key, associated).delete_all # Re-create existing notification if necessary
      user.notifications.create! key: key,
                                 message: message,
                                 path: path,
                                 associated: associated,
                                 clear_manually: clear_manually
    end

    def deliver_email!(mailer, method, *args)
      mailer.deliver_later method, *args
    end
  end
end
