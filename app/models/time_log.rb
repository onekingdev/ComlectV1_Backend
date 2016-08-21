# frozen_string_literal: true
class TimeLog < ActiveRecord::Base
  belongs_to :timesheet

  validates :description, :hours, presence: true
  validates :hours, numericality: { greater_than: 0 }
end
