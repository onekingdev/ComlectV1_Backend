# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :thread, polymorphic: true
  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true, optional: true

  scope :preload_association, -> { preload(:thread, :sender, :recipient) }
  scope :recent, -> { order(created_at: :desc) }
  scope :notifiable, -> {
                       where(read_by_recipient: false).where('created_at < ?',
                                                             Time.zone.now - 1.minute).where.not(recipient_id: nil)
                     }
  scope :unread, -> { where(read_by_recipient: false) }
  scope :between, ->(type, id) {
    where(thread: nil)
      .where('(recipient_type = :type AND recipient_id = :id) OR (sender_type = :type AND sender_id = :id)',
             type: type, id: id.to_i)
  }
  scope :business_specialist, ->(b_id, s_id) {
    where(recipient_id: s_id, sender_id: b_id, recipient_type: 'Specialist', sender_type: 'Business')
      .recent.or(where(recipient_id: b_id, sender_id: s_id, recipient_type: 'Business', sender_type: 'Specialist').recent)
  }
  scope :direct, -> { where(thread_id: nil) }

  include FileUploader[:file]

  attr_accessor :project

  validates :message, presence: true, unless: ->(msg) { msg.file.present? }

  def self.threads_for(subject)
    query = <<-SQL
    WITH summary AS (
      SELECT *, ROW_NUMBER() OVER(PARTITION BY m.thread_id ORDER BY m.created_at DESC) AS n
      FROM messages AS m
    )
    SELECT DISTINCT(summary.thread_type, summary.thread_id), * FROM summary WHERE summary.n = 1 AND
      ((sender_type = :type AND sender_id = :id) OR
       (recipient_type = :type AND recipient_id = :id))
    ORDER BY summary.created_at DESC
    SQL
    find_by_sql([query, { id: subject.id, type: subject.model_name.name }])
  end

  def first_notification?; end

  def messages
    if thread
      Message.where(thread: thread)
    else
      same = '(recipient_type = :rcpt_type AND recipient_id = :rcpt_id AND
               sender_type = :sender_type AND sender_id = :sender_id)'
      reverse = '(recipient_type = :sender_type AND recipient_id = :sender_id AND
                  sender_type = :rcpt_type AND sender_id = :rcpt_id)'
      Message.where(thread: nil).where "#{same} OR #{reverse}",
                                       rcpt_type: recipient_type,
                                       rcpt_id: recipient_id,
                                       sender_type: sender_type,
                                       sender_id: sender_id
    end
  end

  def other_party(party)
    sender == party ? recipient : sender
  end

  def sender?(sender)
    self.sender == sender
  end

  def send_as_email!
    MessageMailer.deliver_later :first_contact, sender, recipient, message, project
    true
  end

  def file_name
    file.metadata['filename']
  end

  def owner_name
    sender.to_s
  end
end
