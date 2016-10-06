# frozen_string_literal: true
class Business::NotificationSettingsController < ApplicationController
  before_action :require_business!

  def index
    @business = current_business
    @settings = Business.default_settings[:notifications]
  end

  def update
    setting = Business.default_settings[:notifications][params[:id]]
    return render_404 unless setting
    current_business.settings(:notifications).update_attributes! params[:id] => (params[:value] == 'true')
    render nothing: true, status: :ok
  end
end
