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
      specialist = rating.project.specialist
      return unless Notification.enabled?(specialist, :got_rated)
      dispatcher = Dispatcher.new(specialist.user)
      dispatcher.deliver_notification! :specialist_got_rated,
                                       h.specialists_dashboard_path(anchor: 'ratings-reviews'),
                                       rating
      dispatcher.deliver_email! RatingMailer, :notification, rating.id
    end

    def business_got_rated!(rating)
      business = rating.project.business
      return unless Notification.enabled?(business, :got_rated)
      dispatcher = Dispatcher.new(business.user)
      dispatcher.deliver_notification! :business_got_rated,
                                       h.business_dashboard_path(anchor: 'ratings-reviews'),
                                       rating
      dispatcher.deliver_email! RatingMailer, :notification, rating.id
    end

    def got_project_message!(message)
      project = message.thread
      key, path, who = if message.sender == project.specialist
                         [:business_got_project_message, h.business_project_dashboard_path(project), project.business]
                       else
                         [:specialist_got_project_message, h.project_dashboard_path(project), project.specialist]
                       end
      dispatcher = Dispatcher.new(who.user)
      dispatcher.deliver_notification! key, path, project, clear_manually: true
      dispatcher.deliver_email! ProjectMessageMailer, :notification, message.id
    end

    def project_ended!(project)
      business_project_ended! project
      specialist_project_ended! project
    end

    def business_project_ended!(project)
      return unless Notification.enabled?(project.business, :project_ended)
      business_dispatcher = Dispatcher.new(project.business.user)
      business_dispatcher.deliver_notification! :business_project_ended,
                                                h.business_project_dashboard_path(project),
                                                project
      business_dispatcher.deliver_email! ProjectEndedMailer, :business_message, project.id
    end

    def specialist_project_ended!(project)
      specialist_dispatcher = Dispatcher.new(project.specialist.user)
      specialist_dispatcher.deliver_notification! :specialist_project_ended,
                                                  h.project_dashboard_path(project),
                                                  project,
                                                  project_title: project.title
      specialist_dispatcher.deliver_email! ProjectEndedMailer, :specialist_message, project.id
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
