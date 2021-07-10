# frozen_string_literal: true

class RegulatoryChange < ActiveRecord::Base
  belongs_to :annual_report
  validates :change, presence: true
end
