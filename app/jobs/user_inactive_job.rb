# frozen_string_literal: true
class UserInactiveJob < ActiveJob::Base
  queue_as :default

  def perform(user_id = nil)
    return process_all if user_id.nil?
    user = User.find_by(id: user_id)
    User::Inactive.process! user
  end

  private

  def process_all
    User.inactive.each do |user|
      self.class.perform_later user.id
    end
  end
end
