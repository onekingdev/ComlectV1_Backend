# frozen_string_literal: true

class Business::HelpsController < ApplicationController
  before_action :require_business!

  def show
    @user = current_user
  end
end
