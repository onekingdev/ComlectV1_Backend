# frozen_string_literal: true
class UserInactiveJob < ActiveJob::Base
  queue_as :default

  delegate :perform_later, to: :class

  def perform(user_id = nil)
    return process_all if user_id.nil?
    user = User.find_by(id: user_id)
    User::Inactive.process! user if user
  end

  private

  def process_all
    User.inactive.pluck(:id).each(&method(:perform_later))
  end
end
