# frozen_string_literal: true

class LocalProject < ApplicationRecord
  has_many :projects
  belongs_to :business
end
