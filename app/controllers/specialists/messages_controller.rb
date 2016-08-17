# frozen_string_literal: true
class Specialists::MessagesController < MessagesController
  before_action :require_specialist!
  before_action :set_sender!

  private

  def set_sender!
    @sender = current_specialist
  end
end
