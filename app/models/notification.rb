# frozen_string_literal: true
class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :associated, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :with_key, -> (key) { where(key: key) }
  scope :associated_with, -> (associated) { where(associated: associated) }
  scope :fetch, -> (key, associated) { with_key(key).associated_with(associated) }

  def self.enabled?(who, notification)
    who.settings(:notifications).public_send(notification)
  end

  def self.clear!(user, key, associated)
    user.notifications.fetch(key, associated).first&.update_attribute :read_at, Time.zone.now
  end
end
