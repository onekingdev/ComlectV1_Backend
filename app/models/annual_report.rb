# frozen_string_literal: true

class AnnualReport < ActiveRecord::Base
  belongs_to :business
  has_many :annual_review_employees, dependent: :destroy
  has_many :regulatory_changes, dependent: :destroy
  has_many :business_changes, dependent: :destroy
  has_many :findings, dependent: :destroy
  accepts_nested_attributes_for :annual_review_employees, allow_destroy: true
  accepts_nested_attributes_for :regulatory_changes, allow_destroy: true
  accepts_nested_attributes_for :business_changes, allow_destroy: true
  accepts_nested_attributes_for :findings, allow_destroy: true
  # after_save :destroy_empties

  def cof_str
    if cof_bits.nil?
      '0000000000000000000000000000000000'
    else
      cof_bits.to_s(2).rjust(34, '0').reverse
    end
  end
end
