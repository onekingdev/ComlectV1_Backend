# frozen_string_literal: true

require 'mail'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    address = Mail::Address.new(value).address
    if address.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      record.public_send("#{attribute}=", address)
    else
      record.errors[attribute] << email_error_message
    end
  rescue Mail::Field::IncompleteParseError
    record.errors[attribute] << email_error_message
  end

  private

  def email_error_message
    options[:message] || I18n.t('activerecord.errors.messages.email')
  end
end
