# frozen_string_literal: true

class ProjectInvitesController < ApplicationController
  prepend_before_action :authenticate_user!
  before_action :require_business!

  def new
    @specialist = Specialist.find_by(username: params[:specialist_username])

    @invite = ProjectInvite::Form.for(
      @specialist,
      current_business.projects.new,
      template: params[:template]
    )
  end

  def create
    @specialist = Specialist.find_by(username: invite_params[:specialist_username])
    modified_params = invite_params
    modified_params[:specialist_id] = @specialist.id
    modified_params.delete(:specialist_username)
    @invite = ProjectInvite::Form.new_from_params(modified_params, current_business)
    if @invite.new_project? && @invite.save
      js_redirect new_business_project_path(invite_id: @invite.id)
    elsif @invite.existing_project? && @invite.save_and_send
      render :create
    else
      render :new
    end
  end

  private

  def invite_params
    params.require(:project_invite).permit(:project_id, :message, :specialist_username)
  end
end
