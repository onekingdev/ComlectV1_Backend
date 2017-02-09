# frozen_string_literal: true
class DiscourseController < ApplicationController
  def specialist_sso
    if current_user.specialist.blank?
      redirect_to root_url
    else
      sso = form_specialist_sso(current_specialist)
      # EXAMPLE url https://discourse-specialist.herokuapp.com/session/sso_login
      redirect_to sso.to_url(ENV['DISCOURSE_SPECIALIST_SSO_URL'])
    end
  end

  def business_sso
    if current_user.business.blank?
      redirect_to root_url
    else
      sso = form_business_sso(current_business)
      # EXAMPLE url https://discourse-business.herokuapp.com/session/sso_login
      redirect_to sso.to_url(ENV['DISCOURSE_BUSINESS_SSO_URL'])
    end
  end

  private

  def form_specialist_sso(specialist)
    secret = ENV['DISCOURSE_SECRET']
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = specialist.user.email
    sso.name = specialist.full_name
    sso.username = specialist.user.email
    sso.external_id = specialist.id
    sso.sso_secret = secret
    sso
  end

  def form_business_sso(business)
    secret = ENV['DISCOURSE_SECRET']
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = business.user.email
    sso.name = business.contact_full_name
    sso.username = business.user.email
    sso.external_id = business.id
    sso.sso_secret = secret
    sso
  end
end
