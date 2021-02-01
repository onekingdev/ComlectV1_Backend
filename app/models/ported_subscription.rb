# frozen_string_literal: true

class PortedSubscription < ActiveRecord::Base
  enum period: { monthly: 0, annual: 1 }
  enum status: { inactive: 0, active: 1 }

  belongs_to :specialist, optional: true

  scope :active, -> { where(status: 1) }
end
