# frozen_string_literal: true

class Api::Settings::ProfileController < ApiController
  skip_before_action :verify_authenticity_token
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

  def destroy
    delete = if @current_someone.class.name == 'Business'
               Business::Delete.new(@current_someone)
             else
               Specialist::Delete.new(@current_someone)
             end
    authorize @current_someone, :freeze?

    if delete.call
      sign_out current_user
      render json: { "deleted": true }.to_json
    else
      respond_with error: 'Could not delete your account at this time', status: :unprocessable_entity
    end
  end

  private

  def general_params
    params.require(:user).permit(:photo, :first_name, :last_name)
  end
end
