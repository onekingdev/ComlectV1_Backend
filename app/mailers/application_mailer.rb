# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Complect <#{ENV.fetch('DEFAULT_MAIL_FROM')}>"

  attr_reader :postmark

  # Use this method so development mails are sent immediately:
  # ProjectMailer.deliver_later :invite, ...
  def self.deliver_later(method, *args)
    message = public_send(method, *args)
    later = ENV['ENABLE_DIRECT_MAILERS'] != '1'
    Rails.env.production? && later ? message.deliver_later : message.deliver_now
  end

  def initialize(*args)
    @postmark = Postmark::ApiClient.new(ENV.fetch('POSTMARK_API_KEY'))
    super
  end

  def mail(headers = {}, &block)
    return deliver_with_template(headers) if Rails.env.production? && headers.key?(:template_id)
    return super if Rails.env.production? || !headers.key?(:template_id)
    super headers do |format|
      format.text do
        model = headers[:template_model].map { |var, value| "#{var}: #{value}" }.join("\n")
        render plain: "Template ID: #{headers[:template_id]}\n\n#{model}"
      end
    end
  end

  private

  def deliver_with_template(headers = {})
    postmark.deliver_with_template({ from: self.class.default[:from] }.merge(headers))
  rescue Postmark::InactiveRecipientError
    true
  end
end
