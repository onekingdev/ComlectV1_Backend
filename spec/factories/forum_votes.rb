# frozen_string_literal: true

FactoryBot.define do
  factory :forum_vote do
    user_id 1
    answer_id 1
    upvote false
  end
end
