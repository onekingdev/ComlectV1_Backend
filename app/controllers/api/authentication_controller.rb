# frozen_string_literal: true

class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token
  skip_before_action :lock_specialist, only: :destroy

  def create
    service = AuthenticationService.call(self, params)
    render json: service.data, status: service.status
  end

  def destroy
    session.delete(:employee_business_id)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    begin
      token = request.headers['Authorization']
      payload = JsonWebToken.decode(token)
      user = User.find(payload['sub'])
      user.update(jwt_hash: SecureRandom.hex(10))
    rescue
      Rails.logger.info 'fixme: session signout bug'
    end

    render json: { result: 'signed_out' }, status: :ok
  end
end
