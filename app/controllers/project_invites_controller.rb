# frozen_string_literal: true
class ProjectInvitesController < ApplicationController
  before_action :require_business!

  def new
    @specialist = Specialist.find(params.require(:specialist_id))
    @invite = ProjectInvite::Form.for(@specialist, current_user.business.projects.new)
  end

  def create
    @invite = ProjectInvite::Form.new_from_params(invite_params, current_business)
    if @invite.new_project? && @invite.save
      js_redirect new_project_path(invite_id: @invite.id)
    elsif @invite.existing_project? && @invite.save_and_send
      render :create
    else
      render :new
    end
  end

  private

  def invite_params
    params.require(:project_invite).permit(:project_id, :message, :specialist_id)
  end
end
