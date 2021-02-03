# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :favorited, polymorphic: true

  validates :favorited_id, uniqueness: { scope: %i[owner_id owner_type favorited_type] }

  def self.remove!(owner, favorited)
    owner.favorites.find_by(favorited: favorited)&.destroy
  end

  def self.toggle!(owner, params)
    owner.favorites.find_by(params)&.destroy || owner.favorites.create!(params)
  end
end
