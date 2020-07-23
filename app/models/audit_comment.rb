# frozen_string_literal: true

class AuditComment < ActiveRecord::Base
  belongs_to :business
  has_one :audit_request
end
