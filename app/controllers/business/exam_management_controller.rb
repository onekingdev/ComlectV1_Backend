# frozen_string_literal: true

class Business::ExamManagementController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def index
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def show
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def portal
    render html: content_tag('auth-layout', '').html_safe, layout: 'vue_onboarding'
  end
end
