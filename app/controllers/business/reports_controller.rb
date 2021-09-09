# frozen_string_literal: true

class Business::ReportsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :require_business!, only: %i[risks]

  def risks
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def organizations
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def financials
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end
end
