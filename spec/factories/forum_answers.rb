# frozen_string_literal: true

FactoryBot.define do
  factory :forum_answer do
    user_id 1
    body 'MyText'
    forum_question_id 1
    reply_to 1
  end
end
