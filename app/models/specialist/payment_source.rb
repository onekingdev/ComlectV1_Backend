# frozen_string_literal: true

class Specialist::PaymentSource < ActiveRecord::Base
  belongs_to :specialist

  def primary?
    primary == true
  end

  def make_primary!
    specialist.payment_sources.update_all primary: false
    update_attribute :primary, true
  end
end
