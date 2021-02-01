# frozen_string_literal: true

class ProjectInvite < ApplicationRecord
  belongs_to :business
  belongs_to :project
  belongs_to :specialist

  enum status: { not_sent: 'not_sent', sent: 'sent' }

  def send_message!
    ProjectMailer.deliver_later :invite, self
    Notification::Deliver.invited_to_project! self
    update_attribute :status, self.class.statuses[:sent]
  end
end
