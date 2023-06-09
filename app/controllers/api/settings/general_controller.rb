# frozen_string_literal: true

class Api::Settings::GeneralController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :require_someone!

  def index
    respond_with @current_someone, serializer: ::Settings::GeneralSerializer
  end

  def update
    if @current_someone.update(general_params)
      respond_with @current_someone, serializer: ::Settings::GeneralSerializer, status: :ok
    else
      respond_with errors: @current_someone.errors, status: :unprocessable_entity
    end
  end

  private

  def general_params
    params.permit(:time_zone, :country, :state, :city, :contact_phone)
  end
end
