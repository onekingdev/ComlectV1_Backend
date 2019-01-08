# frozen_string_literal: true

class ForumAnswer < ActiveRecord::Base
  belongs_to :forum_question
  belongs_to :user
  validates :forum_question, presence: true
  has_many :replies, -> { order(upvotes_cnt: :desc) }, class_name: 'ForumAnswer', foreign_key: :reply_to, dependent: :destroy
  has_many :forum_votes

  scope :direct, -> { where(reply_to: nil).order(upvotes_cnt: :desc) }
  include FileUploader[:file]

  def photo(*args, &block)
    user.business ? user.business.logo(*args, &block) : user.specialist.photo(*args, &block)
  end

  def photo_url(*args, &block)
    user.business ? user.business.logo_url(*args, &block) : user.specialist.photo_url(*args, &block)
  end

  def render_stars
    if user.business
      Business::Decorator.decorate(user.business).render_stars
    else
      Specialist::Decorator.decorate(user.specialist).render_stars
    end
  end

  def ratings_average
    user.business ? user.business.ratings_average : user.specialist.ratings_average
  end

  def rating
    k = 0
    forum_votes.collect(&:upvote).map { |s| k += s ? 1 : -1 }
    k
  end

  def upvotes
    forum_votes.where(upvote: true).count
  end

  def downvotes
    forum_votes.where(upvote: false).count
  end

  def file_name
    file.metadata['filename']
  end

  def update_upvotes_cnt
    update(upvotes_cnt: upvotes)
  end
end
