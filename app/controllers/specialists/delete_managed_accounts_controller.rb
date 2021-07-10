# frozen_string_literal: true

class Specialists::DeleteManagedAccountsController < ApplicationController
  before_action :require_specialist!

  def destroy
    @specialist = Specialist.find(params[:id])
    @delete = Specialist::Delete.new(current_user, @specialist)
    authorize @specialist, :freeze?

    flash[:noticed] = 'Account deleted' if @delete.call
    redirect_to specialists_settings_team_path
  end
end
