# frozen_string_literal: true

class Specialists::NotificationSettingsController < ApplicationController
  before_action :require_specialist!

  def index
    @specialist = current_specialist
    @settings = Specialist.default_settings[:notifications]
  end

  def update
    setting = Specialist.default_settings[:notifications][params[:id]]
    return render_404 unless setting
    current_specialist.settings(:notifications).update_attributes! params[:id] => (params[:value] == 'true')
    render nothing: true, status: :ok
  end
end
