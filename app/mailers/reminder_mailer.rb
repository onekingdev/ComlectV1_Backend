# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def send_today(remindable, past_dues, todays)
    @remindable = remindable
    @past_dues = past_dues
    @todays = todays
    mail(
      to: remindable.user.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Today’s Compliance Tasks',
        message_html: render('reminder_mailer/today_reminders.html'),
        message_text: render('reminder_mailer/today_reminders.text')
      }
    )
  end
end
