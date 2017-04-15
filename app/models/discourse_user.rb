# frozen_string_literal: true
class DiscourseUser
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def sync
    sso.name = name
    sso.username = username
    sso.email = email
    sso.avatar_url = avatar_url
    begin
      api.post '/admin/users/sync_sso', sso.payload
    rescue => e # Silent so user gets saved anyway when applicable
      Appsignal.send_error e
    end
  end

  def email
    object.user.email
  end

  def username
    object.discourse_username! name.parameterize.titleize.delete(' ')
  end

  def avatar_url
    object.photo && object.public? ? object.photo_url(:thumb) : asset_url('icon-specialist.png')
  end

  private

  def asset_url(asset)
    ActionController::Base.helpers.asset_url asset, host: "https://#{ENV.fetch('DEFAULT_URL_HOST')}"
  end

  def api
    @_api ||= DiscourseApi::Client.new(self.class::FORUM_URL).tap do |api|
      api.api_key = self.class::API_KEY
      api.api_username = self.class::API_USER
    end
  end

  def sso
    @_sso ||= DiscourseApi::SingleSignOn.new.tap do |sso|
      sso.sso_secret = ENV.fetch('DISCOURSE_SECRET')
      sso.email = object.user.email
      sso.external_id = object.id
    end
  end
end
