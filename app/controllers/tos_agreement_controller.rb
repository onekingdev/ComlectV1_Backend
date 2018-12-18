# frozen_string_literal: true

class TosAgreementController < ApplicationController
  before_action :authenticate_user!

  def create
    status = params[:status]
    current_user.create_privacy_agreement(request.remote_ip, status)
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
