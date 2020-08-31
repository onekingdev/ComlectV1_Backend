# frozen_string_literal: true

class TeamMember < ActiveRecord::Base
  belongs_to :team
  has_one :seat

  validates :first_name, presence: true
  # validates :last_name, presence: true
  validates :email, presence: true
  validates :title, presence: true

  before_destroy :clear_seat

  def clear_seat
    seat&.unassign
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
