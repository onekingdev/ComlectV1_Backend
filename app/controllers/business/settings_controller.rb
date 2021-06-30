# frozen_string_literal: true

class Business::SettingsController < ApplicationController
  before_action :require_business!

  def show
    @user = current_user
  end
end
