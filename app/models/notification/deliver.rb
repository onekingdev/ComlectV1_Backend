# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Notification::Deliver < Draper::Decorator
  decorates Notification

  # TODO: come up with a better method in order to remove repetitive code

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
        t: { project_title: project.title }
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
        initiator: project.business
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
        initiator: project.business,
        t: { project_title: project.title }
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
        initiator: project.business,
        t: { project_title: project.title }
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
        initiator: project.specialist,
        t: { project_title: project.title }
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
        initiator: project.business,
        t: { project_title: project.title }
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
        associated: project,
        t: { project_title: project.title }
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
        initiator: project.specialist,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def end_project!(request)
      project = request.project
      action_path, action_url = path_and_url :project_dashboard, project
      key = project.fixed_pricing? ? :end_project_fixed : :end_project_hourly
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        t: { business_name: project.business.business_name, project_title: project.title }
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
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def welcome_specialist!(specialist)
      action_path, action_url = path_and_url :specialists_settings_payment
      dispatcher = Dispatcher.new(user: specialist.user, key: :welcome_specialist, action_path: action_path)
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def welcome_business!(business)
      action_path, action_url = path_and_url :business_settings_payment_index
      dispatcher = Dispatcher.new(user: business.user, key: :welcome_business, action_path: action_path)
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    # rubocop:disable Metrics/MethodLength
    def escalated!(issue)
      project = issue.project
      rcv, key, path, url = if issue.user.specialist
                              [
                                project.business.user, :business_escalated,
                                *path_and_url(:business_project_dashboard, project, anchor: "project-messages")
                              ]
                            elsif issue.user.business
                              [
                                project.specialist.user, :specialist_escalated,
                                *path_and_url(:project_dashboard, project, anchor: "project-messages")
                              ]
                            end
      dispatcher = Dispatcher.new(
        user: rcv,
        key: key,
        action_path: path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, url
    end
    # rubocop:enable Metrics/MethodLength

    def invited_to_project!(invite)
      project = invite.project
      action_path = r.project_path(project)
      key = project.full_time? ? :invited_to_job : :invited_to_project
      dispatcher = Dispatcher.new(
        user: invite.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      # No mail notification here
    end

    def project_application!(application)
      project = application.project
      action_path, action_url = path_and_url :business_project_job_applications, project
      key = project.full_time? ? :job_application : :project_application
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: key,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title },
        initiator: application.specialist
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def end_project_accepted!(request)
      project = request.project
      action_path, action_url = path_and_url :business_project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :end_project_accepted,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title },
        initiator: project.specialist
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def start_date_lapsed!(project)
      action_path, action_url = path_and_url :business_dashboard, anchor: 'projects-drafts'
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :start_date_lapsed,
        action_path: action_path,
        associated: project
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def starts_in_48!(project)
      if project.active?
        specialist_project_starting_soon!(project)
        business_project_starting_soon!(project)
      end
      if project.pending?
        project.favorites.each do |favorite|
          apply_to_favorited!(favorite)
        end
        pending_project_starting_soon!(project)
      end
    end

    def specialist_project_starting_soon!(project)
      action_path, action_url = path_and_url :project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: :specialist_project_starting_soon,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def business_project_starting_soon!(project)
      action_path, action_url = path_and_url :business_project_dashboard, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :business_project_starting_soon,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def apply_to_favorited!(favorite)
      project = favorite.favorited
      action_path, action_url = path_and_url :project, project
      dispatcher = Dispatcher.new(
        user: favorite.owner.user,
        key: :apply_to_favorited,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def pending_project_starting_soon!(project)
      action_path, action_url = path_and_url :business_project_job_applications, project
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: :pending_project_starting_soon,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def ends_in_24!(project)
      business_ends_in_24!(project)
      specialist_ends_in_24!(project)
    end

    def business_ends_in_24!(project)
      action_path, action_url = path_and_url :business_project_dashboard, project
      key = project.fixed_pricing? ? :business_fixed_project_ends : :business_hourly_project_ends
      dispatcher = Dispatcher.new(
        user: project.business.user,
        key: key,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def specialist_ends_in_24!(project)
      action_path, action_url = path_and_url :project_dashboard, project
      key = project.fixed_pricing? ? :specialist_fixed_project_ends : :specialist_hourly_project_ends
      dispatcher = Dispatcher.new(
        user: project.specialist.user,
        key: key,
        action_path: action_path,
        associated: project,
        t: { project_title: project.title }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    # rubocop:disable Metrics/MethodLength
    def user_inactive!(user)
      key, path, url = if user.specialist
                         [
                           :browse_new_projects,
                           *path_and_url(:projects)
                         ]
                       elsif user.business
                         [
                           :post_new_project,
                           *path_and_url(:new_business_project)
                         ]
                       end
      dispatcher = Dispatcher.new(
        user: user,
        key: key,
        action_path: path,
        associated: user
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, url
    end

    def payment_issue!(user)
      key, path, url = if user.specialist
                         [
                           :specialist_payment_issue,
                           *path_and_url(:specialists_settings_payment)
                         ]
                       elsif user.business
                         [
                           :business_payment_issue,
                           *path_and_url(:business_settings_payment_index)
                         ]
                       end
      dispatcher = Dispatcher.new(
        user: user,
        key: key,
        action_path: path,
        associated: user
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, url
    end

    def transaction_processed!(transaction)
      business_transaction_processed! transaction if transaction.business
      specialist_transaction_processed! transaction if transaction.specialist
    end

    def business_transaction_processed!(transaction)
      action_path, action_url = path_and_url :business_financials, anchor: "charges-processed"
      dispatcher = Dispatcher.new(
        user: transaction.business.user,
        key: :business_transaction_processed,
        action_path: action_path,
        associated: transaction,
        t: { payment_amount: ActionController::Base.helpers.number_to_currency(transaction.amount) }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end

    def specialist_transaction_processed!(transaction)
      action_path, action_url = path_and_url :specialists_financials, anchor: "payments-processed"
      dispatcher = Dispatcher.new(
        user: transaction.specialist.user,
        key: :specialist_transaction_processed,
        action_path: action_path,
        associated: transaction,
        t: { payment_amount: ActionController::Base.helpers.number_to_currency(transaction.specialist_total) }
      )
      dispatcher.deliver_notification!
      NotificationMailer.deliver_later :notification, dispatcher, action_url
    end
  end
  # rubocop:enable Metrics/MethodLength

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
      # Re-create existing notification if necessary
      user.notifications.fetch(key, associated).delete_all

      user.notifications.create!(
        key: key,
        message: message,
        action_path: action_path,
        associated: associated,
        clear_manually: clear_manually,
        initiator: initiator_name,
        img_path: img_path
      )
    end

    private

    def default_img_url
      if Rails.env.production?
        'https://' + Shrine.storages[:store].bucket.name + '.s3.amazonaws.com/icon-specialist.png'
      else
        "/icon-specialist.png"
      end
    end

    def business_name_and_img(business)
      image = if business.logo
                business.logo_url(:thumb).split("?").first
              else
                default_img_url
              end

      [business.business_name, image]
    end

    def specialist_name_and_img(specialist)
      image = if specialist.photo
                specialist.photo_url(:thumb).split("?").first
              else
                default_img_url
              end

      [specialist.first_name, image]
    end

    def initiator_name_and_img(initiator)
      if initiator.class == Business::Decorator || initiator.class == Business
        business_name_and_img(initiator)
      elsif initiator.class == Specialist::Decorator || initiator.class == Specialist
        specialist_name_and_img(initiator)
      else
        ["Complect", default_img_url]
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
