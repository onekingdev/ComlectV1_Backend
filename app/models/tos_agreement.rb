# frozen_string_literal: true

class TosAgreement < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  belongs_to :specialist
end