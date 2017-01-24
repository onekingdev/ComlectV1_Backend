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
      dispatcher = Dispatcher.new(
        user,
        :got_hired,
        action_path,
        application.project,
        initiator: application.project.business.business_name,
        img_path: application.project.business.logo_url(:thumb)
      )
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

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def got_project_message!(message)
      project = message.thread
      key, path, who, init, img = if message.sender == project.specialist
                                    [
                                      :business_got_project_message,
                                      r.business_project_dashboard_path(project),
                                      project.business,
                                      project.specialist.first_name,
                                      project.specialist.photo_url(:thumb)
                                    ]
                                  else
                                    [
                                      :specialist_got_project_message,
                                      r.project_dashboard_path(project),
                                      project.specialist,
                                      project.business.business_name,
                                      project.business.logo_url(:thumb)
                                    ]
                                  end
      dispatcher = Dispatcher.new(who.user, key, path, project, clear_manually: true, initiator: init, img_path: img)
      dispatcher.deliver_notification!
      ProjectMessageMailer.deliver_later(:notification, message.id) if Notification.enabled?(who, :got_message)
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

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
    attr_reader :user, :key, :path, :associated, :clear_manually, :t, :message, :initiator, :img_path

    def def_img
      ActionController::Base.helpers.asset_path("icon-specialist.png")
    end

    # rubocop:disable Metrics/ParameterLists
    def initialize(user, key, path, associated, clear_manually: false, t: {}, initiator: "Complect", img_path: def_img)
      @user = user
      @key = key
      @path = path
      @associated = associated
      @clear_manually = clear_manually
      @t = t
      @message = I18n.t(key, t.merge(scope: 'notification_messages'))
      @initiator = initiator
      @img_path = img_path
    end
    # rubocop:enable Metrics/ParameterLists

    def deliver_notification!
      user.notifications.fetch(key, associated).delete_all # Re-create existing notification if necessary
      user.notifications.create! key: key,
                                 message: message,
                                 path: path,
                                 associated: associated,
                                 clear_manually: clear_manually,
                                 initiator: initiator,
                                 img_path: img_path
    end
  end
end
