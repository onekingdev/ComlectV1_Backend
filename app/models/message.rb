# frozen_string_literal: true
class Message < ActiveRecord::Base
  belongs_to :thread, polymorphic: true
  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  scope :recent, -> { order(created_at: :desc) }

  include FileUploader[:file]

  validates :message, presence: true

  def sender?(sender)
    self.sender == sender
  end
end
