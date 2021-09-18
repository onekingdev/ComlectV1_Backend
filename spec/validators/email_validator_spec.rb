# frozen_string_literal: true

require 'rails_helper'
require 'validators/email_validator'

module Test
  EmailValidatable = Struct.new(:email) do
    include ActiveModel::Validations

    validates :email, email: true
  end
end

describe EmailValidator do
  context 'when email address is valid' do
    subject { Test::EmailValidatable.new 'Jane Foo <jane@example.com>' }

    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'saves only the address portion' do
      expect(subject).to be_valid
      expect(subject.email).to eq 'jane@example.com'
    end
  end
end
