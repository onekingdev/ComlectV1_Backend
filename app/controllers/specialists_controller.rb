# frozen_string_literal: true

class SpecialistsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action -> do
    redirect_to specialist_path(current_user.specialist)
  end, if: -> { user_signed_in? && current_user.specialist }, only: %i[create]

  before_action :authenticate_user!, only: %i[show]
  before_action :require_business!, only: %i[index]

  def index
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def show
    @specialist = Specialist.preload_association.find_by(username: params[:id])
  end

  def new
    render html: content_tag('auth-layout', '').html_safe, layout: 'vue_onboarding'
  end
end
