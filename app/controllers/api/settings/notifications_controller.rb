# frozen_string_literal: true

class Api::Settings::NotificationsController < ApiController
  before_action :require_someone!

  def index
    settings = [:email_notifications, :in_app_notifications, :email_updates].each_with_object({}) { |item, returning|
      returning[item] = @current_someone.settings(item).value
    }
    render json: settings.to_json
  end

  def update
    if @current_someone.default_settings[notify_params[:kind].to_sym][notify_params[:setting]]
      setting = @current_someone.settings(notify_params[:kind].to_sym).value[notify_params[:setting]]
      if setting.nil? || setting == true
        @current_someone.settings(notify_params[:kind].to_sym).update! notify_params[:setting].to_sym => false
        respond_with setting: notify_params[:setting], result: false
      elsif setting == false
        @current_someone.settings(notify_params[:kind].to_sym).update! notify_params[:setting].to_sym => true
        respond_with setting: notify_params[:setting], result: true
      end
    end
  end

  private

  def notify_params
    params.permit(
      :kind,
      :setting
    )
  end
end
