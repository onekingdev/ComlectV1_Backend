# frozen_string_literal: true

class Specialists::SettingsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_specialist!

  # def show
  #   @user = current_user
  #   @specialist = current_specialist
  # end

  def show
    # render html: content_tag('specialist-settings-page', '').html_safe, layout: 'vue_specialist'
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end
end
