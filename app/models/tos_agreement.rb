# frozen_string_literal: true

class TosAgreement < ActiveRecord::Base
  belongs_to :user
  belongs_to :business, optional: true
  belongs_to :specialist, optional: true
end
