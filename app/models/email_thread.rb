# frozen_string_literal: true

class EmailThread < ApplicationRecord
  belongs_to :business
  belongs_to :specialist

  before_create :set_thread_key

  def self.for!(party_a, party_b)
    business, specialist = [party_a, party_b].public_send(party_a.is_a?(Specialist) ? :reverse : :to_a)
    where(business: business, specialist: specialist).first_or_create!
  end

  def inverse_of(email)
    party = [[:business, specialist.user.email], [:specialist, business.contact_email]].detect do |test|
      test[1].casecmp(email.downcase).zero?
    end

    public_send party[0]
  end

  def party_from_email(email)
    party = [[:business, business.contact_email], [:specialist, specialist.user.email]].detect do |test|
      test[1].casecmp(email.downcase).zero?
    end

    public_send party[0]
  end

  private

  def set_thread_key
    loop do
      self.thread_key = SecureRandom.hex(5)
      break if self.class.where(thread_key: thread_key).empty?
    end
  end
end
