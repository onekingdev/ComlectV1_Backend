# frozen_string_literal: true

class Specialists::SettingsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_specialist!

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
  end
end
