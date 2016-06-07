# frozen_string_literal: true
class Jurisdiction < ActiveRecord::Base
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :businesses
end
