# frozen_string_literal: true
class ApplicationDecorator < Draper::Decorator
  private

  def normalize_url(url)
    prefix = url =~ /^https?:\/\// ? nil : 'http://'
    "#{prefix}#{url}"
  end
end
