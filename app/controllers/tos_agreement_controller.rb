# frozen_string_literal: true

class TosAgreementController < ApplicationController
  before_action :authenticate_user!

  def create
    status = params[:status]
    description = params[:description]
    current_user.create_cookie_agreement(request.remote_ip, status, description)
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
