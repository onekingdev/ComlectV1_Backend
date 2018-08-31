# frozen_string_literal: true

class ProjectMessagesController < ApplicationController
  before_action :find_project

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

  def specialist_from_params_or_project
    if params[:specialist_id]
      return params[:specialist_id].to_i if Specialist.find(params[:specialist_id]).applied_projects.where(id: @project.id).present?
    else
      @project.specialist_id
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
    @project = sender.communicable_projects.find(params[:project_id])
  end
end
