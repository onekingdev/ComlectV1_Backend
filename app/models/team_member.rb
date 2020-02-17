# frozen_string_literal: true

class TeamMember < ActiveRecord::Base
  belongs_to :team
  validates :name, presence: true
  validates :email, presence: true
  validates :title, presence: true
end
