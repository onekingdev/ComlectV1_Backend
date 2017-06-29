# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  def self.grouped_collection_for_select(array)
    [array].map do |collection|
      collection.define_singleton_method :all do
        collection
      end
      def collection.label
        'Select all'
      end
      collection
    end
  end

  private

  def grouped_collection_for_select(array)
    self.class.grouped_collection_for_select array
  end

  def normalize_url(url)
    prefix = url.match?(/^https?:\/\//) ? nil : 'http://'
    "#{prefix}#{url}"
  end
end
