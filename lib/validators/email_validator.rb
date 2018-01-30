# frozen_string_literal: true

require 'mail'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    mail = Mail::Address.new(value)
    record.public_send("#{attribute}=", mail.address)
  rescue Mail::Field::IncompleteParseError
    record.errors[attribute] << email_error_message
  end

  private

  def email_error_message
    options[:message] || I18n.t('activerecord.errors.messages.email')
  end
end
