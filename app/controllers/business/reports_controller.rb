# frozen_string_literal: true

class Business::ReportsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :require_business!, only: %i[risks]

  def risks
    # render html: content_tag('business-reports-risks-page', '').html_safe, layout: 'vue_business'
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end
end
