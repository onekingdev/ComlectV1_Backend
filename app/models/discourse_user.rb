# frozen_string_literal: true

class DiscourseUser
  attr_reader :object

  def self.for(record)
    case record
    when Specialist
      Specialist::Discourse.new(record)
    else
      Business::Discourse.new(record)
    end
  end

  def initialize(object)
    @object = object
  end

  def sync
    return unless ENV['ENABLE_DISCOURSE_SYNC'] == '1'

    sso.name = name
    sso.username = username
    sso.email = email
    sso.avatar_url = avatar_url

    begin
      api.post '/admin/users/sync_sso', sso.payload
      save_discourse_id if object.discourse_user_id.blank?
    rescue StandardError => e # Silent so user gets saved anyway when applicable
      Bugsnag.notify(e)
    end
  end

  def suspend
    return if object.discourse_user_id.blank?
    api.put "/admin/users/#{object.discourse_user_id}/suspend"
  rescue StandardError => e
    Bugsnag.notify(e)
  end

  def unsuspend
    return if object.discourse_user_id.blank?
    api.put "/admin/users/#{object.discourse_user_id}/unsuspend"
  rescue StandardError => e
    Bugsnag.notify(e)
  end

  def email
    object.user.email
  end

  def username
    if ENV.fetch('DISCOURSE_BUSINESS_ADMIN_ID').to_i == object.user_id
      ENV.fetch('DISCOURSE_BUSINESS_API_USER')
    elsif ENV.fetch('DISCOURSE_SPECIALIST_ADMIN_ID').to_i == object.user_id
      ENV.fetch('DISCOURSE_SPECIALIST_API_USER')
    else
      object.discourse_username! name.parameterize.titleize.delete(' ')
    end
  end

  def avatar_url
    object.photo && object.public? ? object.photo_url(:thumb) : asset_url('icon-specialist.png')
  end

  def api
    @_api ||= DiscourseApi::Client.new(self.class::FORUM_URL).tap do |api|
      api.api_key = self.class::API_KEY
      api.api_username = self.class::API_USER
    end
  end

  def save_discourse_id
    response = api.get "/users/#{object.discourse_username}"
    object.update_attribute :discourse_user_id, response.body['user']['id']
  end

  private

  def asset_url(asset)
    ActionController::Base.helpers.asset_url(asset)
  end

  def sso
    @_sso ||= DiscourseApi::SingleSignOn.new.tap do |sso|
      sso.sso_secret = ENV.fetch('DISCOURSE_SECRET')
      sso.email = object.user.email
      sso.external_id = object.id
    end
  end
end
