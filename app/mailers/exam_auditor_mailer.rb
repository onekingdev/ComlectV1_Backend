# frozen_string_literal: true

class ExamAuditorMailer < ApplicationMailer
  def invite_auditor(exam, auditor, business)
    @exam = exam
    @auditor = auditor
    @business = business

    mail(
      to: @auditor.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        action: {
          action_label: 'Log In',
          action_url: "#{ENV.fetch('FRONTEND_URL')}/#{generate_exam_url(@exam)}"
        },
        subject: "You've been invited to view #{@business.business_name}'s files",
        message_html: "#{@business.business_name} has invited you to access their secure portal. Log in with your invited email address to view their shared documents."
      }
    )
  end

  def otp(auditor)
    @auditor = auditor

    mail(
      to: @auditor.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Complect verification code',
        message_html: "Thank you for verifying your identity. Your verification code is: <p><center>#{@auditor.otp}</p> <p>Your account security is our top priority. If you did not request this code, please ignore this email.</p>"
      }
    )
  end

  def generate_exam_url(exam)
    "exams/#{exam.share_uuid}"
  end

  def verify_email(user, otp_code)
    @otp_code = otp_code
    @user = user

    mail(
      to: @user.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Complect verification code',
        message_html: render_to_string(template: 'business_mailer/verify_email')
      }
    )
  end
end
