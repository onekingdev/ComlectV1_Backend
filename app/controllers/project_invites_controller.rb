# frozen_string_literal: true

class ProjectInvitesController < ApplicationController
  before_action :require_business!
  before_action :authenticate_user!

  def new
    @specialist = Specialist.find(params.require(:specialist_id))

    @invite = ProjectInvite::Form.for(
      @specialist,
      current_business.projects.new,
      template: params[:template]
    )
  end

  def create
    @invite = ProjectInvite::Form.new_from_params(invite_params, current_business)

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
    params.require(:project_invite).permit(:project_id, :message, :specialist_id)
  end
end
