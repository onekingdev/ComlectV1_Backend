# frozen_string_literal: true

class Business::NotificationSettingsController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :require_business!

  # def index
  #   @business = current_business
  #   @settings = Business.default_settings[:notifications]
  # end

  def index
    render html: content_tag('business-notifications-settings-page', '').html_safe, layout: 'vue_business'
  end

  # def update
  #   setting = Business.default_settings[:notifications][params[:id]]
  #   return render_404 unless setting
  #   current_business.settings(:notifications).update! params[:id] => (params[:value] == 'true')
  #   render nothing: true, status: :ok
  # end
end
