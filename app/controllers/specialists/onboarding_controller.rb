# frozen_string_literal: true

class Specialists::OnboardingController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :authenticate_user!
  before_action :require_specialist!

  # def index
  #   render html: content_tag('specialist-onboarding-page', '',
  #                            ':industry-ids': Industry.all.map(&proc { |ind|
  #                                                                 { id: ind.id,
  #                                                                   name: ind.name }
  #                                                               }).to_json,
  #                            ':jurisdiction-ids': Jurisdiction.all.map(&proc { |ind|
  #                                                                         { id: ind.id,
  #                                                                           name: ind.name }
  #                                                                       }).to_json,
  #                            ':sub-industry-ids': sub_industries(true).to_json,
  #                            ':states': State.fetch_all_usa.to_json,
  #                            ':timezones': timezones_array.to_json).html_safe, layout: 'vue_onboarding'
  # end

  def index
    render html: content_tag('auth-layoyt', '').html_safe, layout: 'vue_onboarding'
  end

  def subscribe
    render json: { error: 'Not implemented ' }
  end
end
