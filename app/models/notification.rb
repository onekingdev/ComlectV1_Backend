# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :associated, polymorphic: true

  scope :unread, -> { where(read_at: nil).order(created_at: :desc) }
  scope :with_key, ->(key) { where(key: key) }
  scope :associated_with, ->(associated) { where(associated: associated) }
  scope :fetch, ->(key, associated) { with_key(key).associated_with(associated) }
  scope :clear_automatically, -> { where(clear_manually: false) }
  scope :forum, -> { where(key: %w[forum_comment forum_answer industry_forum_question]) }
  scope :not_forum, -> { where.not(key: %w[forum_comment forum_answer industry_forum_question]) }

  def self.enabled?(who, notification)
    who.settings(:notifications).public_send(notification)
  end

  def self.clear!(user, key, associated)
    user.notifications.fetch(key, associated).update_all read_at: Time.zone.now
  end

  def self.clear_by_path!(user, action_path)
    user.notifications.clear_automatically.where(action_path: action_path).update_all read_at: Time.zone.now
  end
end
