# frozen_string_literal: true

class Business::HelpsController < ApplicationController
  def show
    @user = current_user
  end
end
