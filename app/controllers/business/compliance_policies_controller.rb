# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def index
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end

  def show
    render html: content_tag('main-layout', '',
                             ':policy-id': params[:id]).html_safe, layout: 'vue_builder_layout'
  end

  def entire
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end
end
