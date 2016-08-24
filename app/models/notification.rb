# frozen_string_literal: true
class Notification < ActiveRecord::Base
  belongs_to :user

  scope :unread, -> { where(read_at: nil) }
end
