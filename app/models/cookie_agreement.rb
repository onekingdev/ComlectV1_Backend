# frozen_string_literal: true

class CookieAgreement < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :business, optional: true
  belongs_to :specialist, optional: true
end
