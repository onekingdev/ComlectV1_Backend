# frozen_string_literal: true

class Specialist::PaymentSource < ActiveRecord::Base
  belongs_to :specialist

  def primary?
    primary == true
  end
end
