# frozen_string_literal: true
class ProjectEnd < ActiveRecord::Base
  belongs_to :project

  scope :pending, -> { where(status: nil) }
end
