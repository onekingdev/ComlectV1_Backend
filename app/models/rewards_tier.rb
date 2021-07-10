# frozen_string_literal: true

class RewardsTier < ApplicationRecord
  def self.default
    find_by(name: 'None')
  end
end
