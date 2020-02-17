# frozen_string_literal: true

class Team < ActiveRecord::Base
  belongs_to :business
  has_many :team_members
  accepts_nested_attributes_for :team_members
  validates :name, presence: true
end
