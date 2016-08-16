# frozen_string_literal: true
class JobApplication < ActiveRecord::Base
  belongs_to :specialist
  belongs_to :project
  has_one :user, through: :specialist

  scope :by, -> (specialist) { where(specialist_id: specialist) }

  validates :message, presence: true
  validates :project_id, uniqueness: { scope: :specialist_id }
end
