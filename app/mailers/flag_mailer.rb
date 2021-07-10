# frozen_string_literal: true

class FlagMailer < ApplicationMailer
  def flagged_content(flag_id)
    @flag = Flag.find(flag_id)
    mail to: ENV.fetch('HELP_MAIL_FROM'),
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'Content flagged',
           message_html: render('flagged_content.html'),
           message_text: render('flagged_content.text')
         }
  end
end
