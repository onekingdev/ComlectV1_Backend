# frozen_string_literal: true

class DiscourseController < ApplicationController
  def specialist_sso
    if !signed_in? || current_user.specialist.blank?
      redirect_to root_url
    else
      sso = form_specialist_sso(current_specialist)
      # EXAMPLE url https://discourse-specialist.herokuapp.com/session/sso_login
      redirect_to sso.to_url(ENV.fetch('DISCOURSE_SPECIALIST_SSO_URL'))
    end
  end

  def business_sso
    if !signed_in? || current_user.business.blank?
      redirect_to root_url
    else
      sso = form_business_sso(current_business)
      # EXAMPLE url https://discourse-business.herokuapp.com/session/sso_login
      redirect_to sso.to_url(ENV.fetch('DISCOURSE_BUSINESS_SSO_URL'))
    end
  end

  private

  def form_specialist_sso(specialist)
    sso(specialist).tap do |sso|
      sso.email = specialist.user.email
      sso.name = specialist.full_name
      sso.username = specialist.discourse_username!(
        "#{specialist.first_name} #{specialist.last_name[0]}".parameterize.titleize.delete(' ')
      )
      sso.avatar_url = specialist.photo ? specialist.photo_url(:thumb) : asset_url('icon-specialist.png')
    end
  end

  def form_business_sso(business)
    sso(business).tap do |sso|
      sso.email = business.user.email
      business_name = business.public? ? business.business_name : 'Anonymous'
      sso.name = business_name
      sso.username = business.discourse_username! business_name.parameterize.titleize.delete(' ')

      sso.avatar_url = if business.public? && business.logo
                         business.logo_url(:thumb)
                       else
                         asset_url('icon-business.png')
                       end
    end
  end

  def sso(object)
    secret = ENV.fetch('DISCOURSE_SECRET')
    SingleSignOn.parse(request.query_string, secret).tap do |sso|
      sso.external_id = object.id
      sso.sso_secret = secret
    end
  end

  def asset_url(asset)
    self.class.helpers.asset_url(asset)
  end
end
