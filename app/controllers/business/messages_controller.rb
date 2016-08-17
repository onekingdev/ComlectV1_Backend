# frozen_string_literal: true
class Business::MessagesController < MessagesController
  before_action :require_business!
  before_action :set_sender!

  private

  def set_sender!
    @sender = current_business
  end
end
