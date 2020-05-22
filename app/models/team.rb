# frozen_string_literal: true

class Team < ActiveRecord::Base
  belongs_to :business
  has_many :team_members, dependent: :destroy
  accepts_nested_attributes_for :team_members, allow_destroy: true
  validates :name, presence: true
end
