# frozen_string_literal: true
class ProjectInvite < ActiveRecord::Base
  belongs_to :project
  belongs_to :specialist

  enum status: { not_sent: 'not_sent', sent: 'sent' }

  def send_message!
    # TODO: Send message (Add "\n\nProject Link: <a href="">...</a>" to the bottom)
    update_attribute :status, self.class.statuses[:sent]
  end
end
