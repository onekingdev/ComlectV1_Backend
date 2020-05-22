# frozen_string_literal: true

class Projects::MessagesController < ProjectMessagesController
  before_action :require_specialist!

  def index
    Notification.clear! current_user, :got_project_message, @project
    super
  end

  private

  def path_after_create
    project_dashboard_path @project
  end

  def user_project_messages_path
    project_messages_path @project
  end
  helper_method :user_project_messages_path

  def recipient
    @project.business
  end

  def sender
    current_specialist
  end
  helper_method :sender
end
