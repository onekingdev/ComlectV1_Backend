# frozen_string_literal: true

class Specialists::SettingsController < ApplicationController
  before_action :require_specialist!

  def show
    @user = current_user
  end
end
