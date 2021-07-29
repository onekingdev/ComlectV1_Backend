# frozen_string_literal: true

class Business::ProfileController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_business_layout'
  end
end
