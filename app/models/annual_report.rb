# frozen_string_literal: true

class AnnualReport < ActiveRecord::Base
  belongs_to :business
  has_many :annual_review_employees
  has_many :regulatory_changes
  has_many :business_changes
  has_many :findings
  accepts_nested_attributes_for :annual_review_employees
  accepts_nested_attributes_for :regulatory_changes
  accepts_nested_attributes_for :business_changes
  accepts_nested_attributes_for :findings
end
