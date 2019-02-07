# frozen_string_literal: true

class ForumVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :forum_answer
end
