# frozen_string_literal: true

class ProjectMessagesController < ApplicationController
  prepend_before_action :authenticate_user!
  before_action :find_project
  before_action :read_messages, only: ['index']

  def index
    b_id = current_business ? current_business.id : @project.business_id
    s_id = current_specialist ? current_specialist.id : specialist_from_params_or_project
    @messages = @project.messages.business_specialist(b_id, s_id).page(params[:page]).per(20)
    respond_to do |format|
      format.html do
        return render_messages if params[:page]
        render partial: 'thread', locals: { messages: @messages, me: sender, them: recipient }
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    dst = recipient
    dst = Specialist.find(specialist_from_params_or_project) if dst.blank?
    @message = Message::Create.(@project, message_params.merge(sender: sender, recipient: dst))
    respond_to do |format|
      format.js do
        if @message
          render :new if @message.new_record?
        else
          render nothing: true
        end
      end
      format.html do
        alert = @message.new_record? ? @message.errors.messages.values.flatten.to_sentence : nil
        redirect_to path_after_create, alert: alert
      end
    end
  end

  private

  def read_messages
    @project.messages.where(recipient_id: current_business.id).update_all(read_by_recipient: true) if current_business
    @project.messages.where(recipient_id: current_specialist.id).update_all(read_by_recipient: true) if current_specialist
  end

  def specialist_from_params_or_project
    if params[:specialist_username]
      spec = Specialist.find_by(username: params[:specialist_username])
      return spec.id if spec.applied_projects.where(id: @project.id).present?
    else
      @project.specialist.id
    end
  end

  def render_messages
    render partial: 'messages/message',
           collection: @messages.map(&method(:decorate)).reverse,
           locals: { me: sender, them: recipient }
  end

  def message_params
    params.require(:message).permit(:message, :file)
  end

  def find_project
    @project = sender.projects.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    head(:not_found) && return
  end
end
