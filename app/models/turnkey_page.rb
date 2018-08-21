# frozen_string_literal: true

class TurnkeyPage < ActiveRecord::Base
  has_many :turnkey_solutions
end
