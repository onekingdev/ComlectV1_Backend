# frozen_string_literal: true

class Business::MessagesController < MessagesController
  before_action :require_business!
  before_action :set_sender!
  before_action :set_thread_path

  private

  def set_thread_path
    @thread_path = business_message_path('thread')
  end

  def set_sender!
    @sender = current_business
  end
end
