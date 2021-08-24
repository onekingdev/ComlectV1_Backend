# frozen_string_literal: true

class Team < ActiveRecord::Base
  belongs_to :business
  has_many :team_members, dependent: :destroy
  has_many :specialist_invitations, class_name: '::Specialist::Invitation'
  has_many :specialists, through: :specialist_invitations
  accepts_nested_attributes_for :team_members, allow_destroy: true
  validates :name, presence: true
end
