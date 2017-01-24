# frozen_string_literal: true
class Notification::Deliver < Draper::Decorator
  decorates Notification

  class << self
    def r
      Rails.application.routes.url_helpers
    end

    def path_and_url(name, *args)
      [
        r.public_send("#{name}_path", *args),
        r.public_send("#{name}_url", *args, host: ENV.fetch('DEFAULT_URL_HOST'))
      ]
    end

    def got_hired!(application)
      user = application.specialist.user
      action_path, action_url = path_and_url :project_dashboard, application.project
      dispatcher = Dispatcher.new(user, :got_hired, action_path, application.project)
      dispatcher.deliver_notification!
      # HireMailer.deliver_later :hired, application
      NotificationMailer.deliver_later :notification, user.email, dispatcher.message, 'Project Dashboard', action_url
    end

    def not_hired!(application)
      user = application.specialist.user
      action_path, action_url = path_and_url :projects
      dispatcher = Dispatcher.new(
        user,
        :not_hired,
        action_path,
        application.project,
        clear_manually: true,
        t: { project_title: application.project.title }
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled? application.specialist, :not_hired
      NotificationMailer.deliver_later(:notification, user.email, dispatcher.message, 'Browse Projects', action_url)
    end

    def got_rated!(rating)
      rating.rater == rating.project.business ? specialist_got_rated!(rating) : business_got_rated!(rating)
    end

    def specialist_got_rated!(rating)
      specialist = rating.project.specialist
      return unless Notification.enabled?(specialist, :got_rated)
      dispatcher = Dispatcher.new(
        specialist.user, :specialist_got_rated,
        r.specialists_dashboard_path(anchor: 'ratings-reviews'),
        rating
      )
      dispatcher.deliver_notification!
      RatingMailer.deliver_later :notification, rating.id
    end

    def business_got_rated!(rating)
      business = rating.project.business
      return unless Notification.enabled?(business, :got_rated)
      dispatcher = Dispatcher.new(
        business.user,
        :business_got_rated,
        r.business_dashboard_path(anchor: 'ratings-reviews'),
        rating
      )
      dispatcher.deliver_notification!
      RatingMailer.deliver_later :notification, rating.id
    end

    def got_project_message!(message)
      project = message.thread
      key, path, who = if message.sender == project.specialist
                         [:business_got_project_message, r.business_project_dashboard_path(project), project.business]
                       else
                         [:specialist_got_project_message, r.project_dashboard_path(project), project.specialist]
                       end
      dispatcher = Dispatcher.new(who.user, key, path, project, clear_manually: true)
      dispatcher.deliver_notification!
      ProjectMessageMailer.deliver_later(:notification, message.id) if Notification.enabled?(who, :got_message)
    end

    def project_ended!(project)
      business_project_ended! project
      specialist_project_ended! project
    end

    def business_project_ended!(project)
      return unless Notification.enabled?(project.business, :project_ended)
      business_dispatcher = Dispatcher.new(
        project.business.user,
        :business_project_ended,
        r.business_project_dashboard_path(project),
        project
      )
      business_dispatcher.deliver_notification!
      ProjectEndedMailer.deliver_later :business_message, project.id
    end

    def specialist_project_ended!(project)
      specialist_dispatcher = Dispatcher.new(
        project.specialist.user,
        :specialist_project_ended,
        r.project_dashboard_path(project),
        project,
        t: { project_title: project.title }
      )
      specialist_dispatcher.deliver_notification!
      ProjectEndedMailer.deliver_later :specialist_message, project.id
    end
  end

  class Dispatcher
    attr_reader :user, :key, :path, :associated, :clear_manually, :t, :message

    # rubocop:disable Metrics/ParameterLists
    def initialize(user, key, path, associated, clear_manually: false, t: {})
      @user = user
      @key = key
      @path = path
      @associated = associated
      @clear_manually = clear_manually
      @t = t
      @message = I18n.t(key, t.merge(scope: 'notification_messages'))
    end
    # rubocop:enable Metrics/ParameterLists

    def deliver_notification!
      user.notifications.fetch(key, associated).delete_all # Re-create existing notification if necessary
      user.notifications.create! key: key,
                                 message: message,
                                 path: path,
                                 associated: associated,
                                 clear_manually: clear_manually
    end
  end
end
