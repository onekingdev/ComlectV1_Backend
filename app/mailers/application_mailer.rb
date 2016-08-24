# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_MAIL_FROM')

  attr_reader :postmark

  # Use this method so development mails are sent immediately:
  # ProjectMailer.deliver_later :invite, ...
  def self.deliver_later(method, *args)
    message = public_send(method, *args)
    bypass = ENV['ENABLE_DIRECT_MAILERS'] == '1'
    Rails.env.production? && !bypass ? message.deliver_later : message.deliver_now
  end

  def initialize(*args)
    @postmark = Postmark::ApiClient.new(ENV.fetch('POSTMARK_API_KEY'))
    super
  end

  def mail(headers = {})
    return deliver_via_postmark(headers) if Rails.env.production?
    super headers do |format|
      format.text do
        model = headers[:template_model].map { |var, value| "#{var}: #{value}" }.join("\n")
        render plain: "Template ID: #{headers[:template_id]}\n\n#{model}"
      end
    end
  end

  private

  def deliver_via_postmark(headers = {})
    postmark.deliver_with_template({ from: ENV.fetch('DEFAULT_MAIL_FROM') }.merge(headers))
  end
end
