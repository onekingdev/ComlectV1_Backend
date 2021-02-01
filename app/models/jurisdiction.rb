# frozen_string_literal: true

class Jurisdiction < ApplicationRecord
  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :turnkey_solutions

  scope :sorted, -> { order(name: :asc) }

  def to_s
    name
  end

  def self.ordered_starting_from_usa
    result = []
    Jurisdiction.sorted.each do |item|
      item.name != 'USA' ? result << item : result.unshift(item)
    end
    result
  end
end
