# frozen_string_literal: true

class Specialists::OnboardingController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :authenticate_user!
  before_action :require_specialist!

  def index
    render html: content_tag('specialist-onboarding-page', '').html_safe, layout: 'vue_onboarding'
  end

  def subscribe
    render json: { error: 'Not implemented ' }
  end
end
