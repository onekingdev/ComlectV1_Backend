# frozen_string_literal: true

class Business::ReportsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :require_business!, only: %i[risks]

  def risks
    render html: content_tag('business-reports-risks-page', '').html_safe, layout: 'vue_business'
  end

  def organizations
    render html: content_tag('business-reports-organizations-page', '').html_safe, layout: 'vue_business'
  end
end
