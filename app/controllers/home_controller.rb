# frozen_string_literal: true
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def app_config
    respond_to do |format|
      format.js
    end
  end
end
