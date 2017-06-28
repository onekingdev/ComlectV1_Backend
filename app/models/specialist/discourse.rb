# frozen_string_literal: true

class Specialist::Discourse < DiscourseUser
  FORUM_URL = ENV.fetch('DISCOURSE_SPECIALIST_FORUM')
  API_KEY = ENV.fetch('DISCOURSE_SPECIALIST_API_KEY')
  API_USER = ENV.fetch('DISCOURSE_SPECIALIST_API_USER')

  def name
    object.public? ? object.full_name : 'Anonymous'
  end

  def avatar_url
    object.photo && object.public? ? object.photo_url(:thumb) : asset_url('icon-specialist.png')
  end
end
