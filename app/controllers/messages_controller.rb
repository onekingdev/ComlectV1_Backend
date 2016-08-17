# frozen_string_literal: true
class MessagesController < ApplicationController
  def index
    @threads = Message.threads_for(@sender)
    @thread = @threads.first
  end

  def show
    direct, thread_type, thread_id = params.require(:thread_key).split('/')
    scope = @sender.messages.recent.preload_associations
    if direct == 'direct'
      @thread = scope.between(thread_type, thread_id).first
    else
      thread_id = thread_type
      thread_type = direct
      @thread = scope.find_by(thread_type: thread_type, thread_id: thread_id)
    end
  end
end
