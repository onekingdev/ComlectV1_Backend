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
        subject: 'Your verification code',
        message_html: "Below is your one time verification code. This code will expire in 5 minutes. <p>#{@auditor.otp}</p>If you did not request this, please ignore this email."
      }
    )
  end

  def generate_exam_url(exam)
    environment = ENV['STRIPE_PUBLISHABLE_KEY'].start_with?('pk_test') ? 'staging' : 'production'
    return "https://app.complect.com/exams/#{exam.share_uuid}" if environment == 'production'
    "https://demo.complect.com/exams/#{exam.share_uuid}"
  end

  def verify_email(user, otp_code)
    @otp_code = otp_code
    @user = user

    mail(
      to: @user.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Your verification code',
        message_html: render_to_string(template: 'business_mailer/verify_email')
      }
    )
  end
end
