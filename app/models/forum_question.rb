# frozen_string_literal: true

class ForumQuestion < ActiveRecord::Base
  has_and_belongs_to_many :industries, optional: true
  has_and_belongs_to_many :jurisdictions, optional: true
  belongs_to :business
  has_many :forum_answers
  validates :jurisdictions, :industries, :title, :body, :state, :business_id, presence: true
  # before_save :generate_url

  def keywords
    (title + ' ' + body).downcase.gsub(/[^a-z0-9\s]/i, '').split(' ').collect(&proc { |s| s if s.length > 4 }).reject(&:nil?).uniq
  end

  def generate_url
    url_base = title.parameterize
    new_url = url_base
    counter = 1
    while ForumQuestion.where(url: new_url).where.not(id: id).count.positive?
      new_url = "#{url_base}-#{counter}"
      counter += 1
    end
    update(url: new_url)
  end
end
