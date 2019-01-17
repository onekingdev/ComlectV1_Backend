# frozen_string_literal: true

class ForumQuestion < ActiveRecord::Base
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_many :forum_answers
  validates :jurisdictions, :industries, :title, :body, :state, presence: true

  def keywords
    (title + ' ' + body).downcase.gsub(/[^a-z0-9\s]/i, '').split(' ').collect(&proc { |s| s if s.length > 4 }).reject(&:nil?).uniq
  end
end
