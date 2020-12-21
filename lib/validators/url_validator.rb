# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << url_error_message unless valid?(value)
  end

  private

  def valid?(value)
    URI.parse(value)
  rescue StandardError
    false
  end

  def url_error_message
    options[:message] || I18n.t('activerecord.errors.messages.url')
  end
end
