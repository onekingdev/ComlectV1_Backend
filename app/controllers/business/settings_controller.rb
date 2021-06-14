# frozen_string_literal: true

class Business::SettingsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  # def show
  #   @user = current_user
  # end

  def show
    render html: content_tag('business-settings-page', '').html_safe, layout: 'vue_business'
  end

end
