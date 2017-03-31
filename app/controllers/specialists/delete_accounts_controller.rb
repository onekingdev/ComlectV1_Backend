# frozen_string_literal: true
class Specialists::DeleteAccountsController < ApplicationController
  before_action :require_specialist!

  def show
    @user = current_user
    @freeze = Specialist::Freeze.new(@user.specialist)
  end

  def destroy
    @user = current_user
    @freeze = Specialist::Freeze.new(@user.specialist)
    authorize @user.specialist, :freeze?
    if @user.freeze_specialist_account!
      sign_out @user
      redirect_to root_path
    else
      flash.now.notice = 'Could not delete your account at this time'
      render :show
    end
  end
end
