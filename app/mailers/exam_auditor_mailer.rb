# frozen_string_literal: true

class ExamAuditorMailer < ApplicationMailer
  def invite_auditor(exam, auditor, business)
    @exam = exam
    @auditor = auditor
    @business = business

    mail(
      to: @auditor.email,
      template_id: ENV.fetch('POSTMARK_PERSONAL_TEMPLATE_ID'),
      template_model: {
        subject: "#{@business.business_name} Portal Access",
        message_html: "Welcome! You’ve been invited to #{@business.business_name}’s
         exam management portal. Please click the link below to access the documents that have been
         shared with you. <br><br><a href='#{generate_exam_url(@exam)}'>#{generate_exam_url(@exam)}</a>"
      }
    )
  end

  def otp(auditor)
    @auditor = auditor

    mail(
      to: @auditor.email,
      template_id: ENV.fetch('POSTMARK_PERSONAL_TEMPLATE_ID'),
      template_model: {
        subject: 'Portal Access Key',
        message_html: "This key will expire in 5 minutes: #{@auditor.otp}"
      }
    )
  end

  def generate_exam_url(exam)
    environment = ENV['STRIPE_PUBLISHABLE_KEY'].start_with?('pk_test') ? 'staging' : 'production'
    return "https://app.complect.com/exams/#{exam.share_uuid}" if environment == 'production'
    "https://staging.complect.com/exams/#{exam.share_uuid}"
  end

  def verify_email(user, otp_code)
    @otp_code = otp_code
    @user = user

    mail(
      to: @user.email,
      template_model: {
        subject: 'Confirm your email',
        message_html: render_to_string(template: 'business_mailer/verify_email')
      }
    )
  end
end
