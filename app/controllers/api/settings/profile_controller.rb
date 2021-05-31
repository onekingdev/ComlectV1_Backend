# frozen_string_literal: true

class Api::Settings::ProfileController < ApiController
    before_action :require_someone!

    def index
      respond_with @current_someone, serializer: ::Settings::ProfileSerializer
    end

    def update
      if @current_someone.update(general_params)
        respond_with @current_someone, serializer: ::Settings::ProfileSerializer, status: :ok
      else
        respond_with errors: @current_someone.errors, status: :unprocessable_entity
      end
    end

    private

    def general_params
      params.require(:user).permit(:photo, :first_name, :last_name)
    end
  end
