# frozen_string_literal: true

class Business::SpecialistsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  def index
    render html: content_tag('business-marketplace-page', '').html_safe, layout: 'vue_business'
  end
end
