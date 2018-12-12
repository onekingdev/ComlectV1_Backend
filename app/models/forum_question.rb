# frozen_string_literal: true

class ForumQuestion < ActiveRecord::Base
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_many :forum_answers
  validates :jurisdictions, :industries, :title, :body, :state, presence: true
end
