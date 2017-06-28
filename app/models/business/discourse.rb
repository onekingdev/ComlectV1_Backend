# frozen_string_literal: true

class Business::Discourse < DiscourseUser
  FORUM_URL = ENV.fetch('DISCOURSE_BUSINESS_FORUM')
  API_KEY = ENV.fetch('DISCOURSE_BUSINESS_API_KEY')
  API_USER = ENV.fetch('DISCOURSE_BUSINESS_API_USER')

  def name
    object.public? ? object.business_name : 'Anonymous'
  end

  def avatar_url
    object.logo && object.public? ? object.logo_url(:thumb) : asset_url('icon-business.png')
  end
end
