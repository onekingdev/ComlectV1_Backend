# frozen_string_literal: true

class Business::AnnualReviewsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  def index
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  def show
    render html: content_tag('main-layoyt',
                             '',
                             ':annual-id': params[:id])
      .html_safe, layout: 'vue_main_layout'
  end

  def revcat
    render html: content_tag('main-layoyt',
                             '',
                             ':annual-id': params[:id],
                             ':revcat-id': params[:revcat])
      .html_safe, layout: 'vue_main_layout'
  end
end
