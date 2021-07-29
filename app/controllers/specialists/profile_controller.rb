# frozen_string_literal: true

class Specialists::ProfileController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_specialist!

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end
end
