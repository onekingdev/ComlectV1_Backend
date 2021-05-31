# frozen_string_literal: true

class Api::Settings::GeneralController < ApiController
    before_action :require_someone!

    def index
      if @current_someone.class.name == "Specialist"
        @current_someone[:contact_phone] = general_params[:contact_phone]
      end
      respond_with @current_someone, serializer: ::Settings::GeneralSerializer
    end

    def update
      if @current_someone.class.name == "Specialist"
        general_params[:phone] = general_params[:contact_phone]
        general_params.delete!(:contact_phone)
      end
      if @current_someone.update(params)
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
