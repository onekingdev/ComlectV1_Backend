# frozen_string_literal: true

class Business::NotificationSettingsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  def index
    render html: content_tag('main-layout', '').html_safe, layout: 'vue_business_layout'
  end
end
