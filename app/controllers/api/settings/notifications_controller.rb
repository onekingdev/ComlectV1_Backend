# frozen_string_literal: true

class Api::Settings::NotificationsController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :require_someone!

  def index
    settings = %i[email_notifications in_app_notifications email_updates].each_with_object({}) do |item, returning|
      returning[item] = @current_someone.settings(item).value
    end
    render json: settings.to_json
  end

  def update
    kind = notifications_params[:kind].to_sym
    setting = notifications_params[:setting].to_sym

    if @current_someone.default_settings[kind][setting.to_s]
      cur_setting = @current_someone.settings(kind).value[setting.to_s]
      if cur_setting.nil? || cur_setting
        @current_someone.settings(kind).update! setting => false
        respond_with setting: setting, result: false
      else
        @current_someone.settings(kind).update! setting => true
        respond_with setting: setting, result: true
      end
    else
      respond_with error: :unknown_parameter
    end
  end

  private

  def notifications_params
    params.permit(
      :kind,
      :setting
    )
  end
end
