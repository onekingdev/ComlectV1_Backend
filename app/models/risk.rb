# frozen_string_literal: true

class Risk < ApplicationRecord
  has_and_belongs_to_many :compliance_policies
  belongs_to :business

  validates :name, presence: true
  validates :impact, presence: true
  validates :likelihood, presence: true

  def risk_level
    if likelihood.positive? && impact == 2
      2
    elsif likelihood < 2 && impact.zero?
      0
    else
      1
    end
  end
end
