# frozen_string_literal: true

class Business::AnnualReviewsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  def index
    # render html: content_tag('business-annuals-page', '').html_safe, layout: 'vue_business'
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  def show
    render html: content_tag('business-annual-general-page',
                             '',
                             ':annual-id': params[:id])
      .html_safe, layout: 'vue_business'
  end

  def revcat
    render html: content_tag('business-annual-review-page',
                             '',
                             ':annual-id': params[:id],
                             ':revcat-id': params[:revcat])
      .html_safe, layout: 'vue_business'
  end
end
