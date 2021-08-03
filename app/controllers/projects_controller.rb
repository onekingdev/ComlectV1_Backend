# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ActionView::Helpers::TagHelper

  prepend_before_action :authenticate_user!
  before_action :require_specialist!

  def index
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
  end

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
  end
end
