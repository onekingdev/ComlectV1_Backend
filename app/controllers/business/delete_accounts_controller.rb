# frozen_string_literal: true

class Business::DeleteAccountsController < ApplicationController
  before_action :require_business!

  def show
    @user   = current_user
    @delete = Business::Delete.new(@user.business)
  end

  def destroy
    @user   = current_user
    @delete = Business::Delete.new(@user.business)
    if @delete.call
      sign_out @user
      redirect_to root_path
    else
      flash.now.notice = 'Could not delete your account at this time'
      render :show
    end
  end
end
