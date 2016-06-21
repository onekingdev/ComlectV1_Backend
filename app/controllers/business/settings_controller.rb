# frozen_string_literal: true
class Business::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
end
