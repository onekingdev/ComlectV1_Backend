# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Notification::Deliver < Draper::Decorator
  decorates Notification

  class << self
    def r
      Rails.application.routes.url_helpers
    end

    def path_and_url(name, *args)
      [
        r.public_send("#{name}_path", *args),
        r.public_send("#{name}_url", *args)
      ]
    end

    def got_hired!(application)
      project = application.project
      action_path, action_url = path_and_url :project_dashboard, project
      key = project.full_time? ? :got_hired_job : :got_hired_project
      dispatcher = Dispatcher.new(
        user: application.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        initiator: project.business,
        t: { job_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def not_hired!(application)
      project = application.project
      action_path, action_url = path_and_url :projects
      key = project.full_time? ? :not_hired_job : :not_hired_project
      dispatcher = Dispatcher.new(
        user: application.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        initiator: project.business,
        clear_manually: true,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled? application.specialist, :not_hired
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def got_rated!(rating)
      rating.rater == rating.project.business ? specialist_got_rated!(rating) : business_got_rated!(rating)
    end

    def specialist_got_rated!(rating)
      project = rating.project
      specialist = project.specialist
      action_path, action_url = path_and_url :specialists_dashboard, anchor: 'ratings-reviews'
      dispatcher = Dispatcher.new(
        user: specialist.user,
        key: :got_rated,
        action_path: action_path,
        associated: rating,
        initiator: rating.project.business
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled?(specialist, :got_rated)
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def business_got_rated!(rating)
      project = rating.project
      business = project.business
      action_path, action_url = path_and_url :business_dashboard, anchor: 'ratings-reviews'
      dispatcher = Dispatcher.new(
        user: business.user,
        key: :got_rated,
        action_path: action_path,
        associated: rating,
        initiator: project.specialist
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled?(business, :got_rated)
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    # rubocop:disable Metrics/MethodLength
    def got_project_message!(message)
      project = message.thread
      init, rcv, path, url = if message.sender == project.business
                               [
                                 project.business, project.specialist.user,
                                 *path_and_url(:project_dashboard, project, anchor: "project-messages")
                               ]
                             else
                               [
                                 project.specialist, project.business.user,
                                 *path_and_url(:business_project_dashboard, project, anchor: "project-messages")
                               ]
                             end
      dispatcher = Dispatcher.new(
        user: rcv,
        key: :got_project_message,
        action_path: path,
        associated: project,
        clear_manually: true,
        initiator: init,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled?(init, :got_message)
      NotificationMailer.deliver_later :notification, dispatcher, url
    end
    # rubocop:enable Metrics/MethodLength

    def project_ended!(project)
      business_project_ended! project
      specialist_project_ended! project
    end

    def business_project_ended!(project)
      action_path, action_url = path_and_url :new_business_project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :business_project_ended,
        action_path: action_path,
        associated: project
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled?(project.business, :marketing_emails)
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def specialist_project_ended!(project)
      action_path, action_url = path_and_url :projects
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: :specialist_project_ended,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      return unless Notification.enabled?(project.specialist, :marketing_emails)
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def specialist_timesheet_disputed!(timesheet)
      project = timesheet.project
      action_path, action_url = path_and_url :project_dashboard, project, anchor: "project-timesheets"
      dispatcher = Dispatcher.new(
        user: timesheet.specialist.user,
        key: :timesheet_disputed,
        action_path: action_path,
        associated: project,
        initiator: project.business
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def project_question!(question)
      project = question.project
      action_path, action_url = path_and_url :business_project, project, anchor: "q-a"
      key = project.full_time? ? :job_question : :project_question
      dispatcher = Dispatcher.new(
        user: question.project.business.user,
        key: key,
        action_path: action_path,
        associated: project,
        initiator: question.specialist,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def project_answer!(answer)
      project = answer.project
      action_path, action_url = path_and_url :project, project, anchor: "q-a"
      key = project.full_time? ? :job_answer : :project_answer
      dispatcher = Dispatcher.new(
        user: answer.question.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        initiator: project.business
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def timesheet_submitted!(timesheet)
      project = timesheet.project
      action_path, action_url = path_and_url :business_project_dashboard, project, anchor: "project-timesheets"
      dispatcher = Dispatcher.new(
        user: timesheet.business.user,
        key: :timesheet_submitted,
        action_path: action_path,
        associated: project,
        initiator: project.specialist
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def extend_project!(request)
      project = request.project
      action_path, action_url = path_and_url :project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: :extend_project,
        action_path: action_path,
        associated: project,
        initiator: project.business
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def extension_denied!(extension)
      project = extension.project
      action_path, action_url = path_and_url :business_project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :extension_denied,
        action_path: action_path,
        associated: project
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def extension_accepted!(extension)
      project = extension.project
      action_path, action_url = path_and_url :business_project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :extension_accepted,
        action_path: action_path,
        associated: project,
        initiator: project.specialist
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def end_project!(request)
      project = request.project
      action_path, action_url = path_and_url :project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: :end_project,
        action_path: action_path,
        associated: project,
        t: { business_name: project.business.business_name }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def end_project_denied!(request)
      project = request.project
      action_path, action_url = path_and_url :business_project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :end_project_denied,
        action_path: action_path,
        associated: project
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def welcome_specialist!(specialist)
      action_path, action_url = path_and_url :specialists_settings_payment
      dispatcher = Dispatcher.new(
        user: specialist.user,
        key: :welcome_specialist,
        action_path: action_path
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def welcome_business!(business)
      action_path, action_url = path_and_url :business_settings_payment_index
      dispatcher = Dispatcher.new(
        user: business.user,
        key: :welcome_business,
        action_path: action_path
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end
  end

  class Dispatcher
    attr_reader :user, :key, :action_path, :associated, :clear_manually, :t, :message,
                :initiator, :initiator_name, :img_path, :message_mail, :subject, :action_label

    # rubocop:disable Metrics/ParameterLists
    def initialize(user: nil, key: nil, action_path: nil, associated: nil, clear_manually: false, t: {}, initiator: nil)
      @user = user
      @key = key
      @action_path = action_path
      @associated = associated
      @clear_manually = clear_manually
      @t = t
      @message = I18n.t("#{key}.message", t.merge(scope: 'notification_messages'))
      @initiator = initiator
      @message_mail = message_mail_handler(key, t)
      @action_label = I18n.t("#{key}.action_label", t.merge(scope: 'notification_messages'))
      @subject = I18n.t("#{key}.subject", t.merge(scope: 'notification_messages'))
      @initiator_name, @img_path = initiator_name_and_img(@initiator)
    end
    # rubocop:enable Metrics/ParameterLists

    def deliver_notification!
      user.notifications.fetch(key, associated).delete_all # Re-create existing notification if necessary
      user.notifications.create! key: key,
                                 message: message,
                                 action_path: action_path,
                                 associated: associated,
                                 clear_manually: clear_manually,
                                 initiator: initiator_name,
                                 img_path: img_path
    end

    private

    def initiator_name_and_img(initiator)
      if initiator.class == Business::Decorator || initiator.class == Business
        [initiator.business_name, initiator.logo_url(:thumb)]
      elsif initiator.class == Specialist::Decorator || initiator.class == Specialist
        [initiator.first_name, initiator.photo_url(:thumb)]
      else
        ["Complect", ActionController::Base.helpers.asset_path("icon-specialist.png")]
      end
    end

    def message_mail_handler(key, t)
      if I18n.t("notification_messages.#{key}").keys.include? :message_mail
        I18n.t("#{key}.message_mail", t.merge(scope: 'notification_messages'))
      else
        I18n.t("#{key}.message", t.merge(scope: 'notification_messages'))
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
