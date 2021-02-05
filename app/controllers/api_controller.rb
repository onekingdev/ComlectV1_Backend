# frozen_string_literal: true

class ApiController < ApplicationController
  respond_to :json
  before_action :set_default_format
  before_action :authenticate_user!

  private

  def set_default_format
    request.format = :json
  end
end
