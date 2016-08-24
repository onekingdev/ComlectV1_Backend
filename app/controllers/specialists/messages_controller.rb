# frozen_string_literal: true
class Specialists::MessagesController < MessagesController
  before_action :require_specialist!
  before_action :set_sender!
  before_action :set_thread_path

  private

  def set_thread_path
    @thread_path = specialists_message_path('thread')
  end

  def set_sender!
    @sender = current_specialist
  end
end
