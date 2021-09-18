# frozen_string_literal: true

require 'rails_helper'
require 'validators/url_validator'

module Test
  UrlValidatable = Struct.new(:url) do
    include ActiveModel::Validations

    validates :url, url: true
  end
end

describe UrlValidator do
  context 'when url is valid' do
    subject { Test::UrlValidatable.new 'https://example.com' }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
