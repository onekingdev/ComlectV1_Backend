# frozen_string_literal: true

class Specialists::HelpsController < ApplicationController
  def show
    @user = current_user
    render 'business/helps/show'
  end
end
