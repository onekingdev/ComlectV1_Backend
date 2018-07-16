# frozen_string_literal: true

class ProjectMessagesController < ApplicationController
  before_action :find_project

  # rubocop:disable Metrics/AbcSize
  def index
    s_id = nil
    b_id = nil
    if current_business
      b_id = current_business.id
      if params[:specialist_id]
        specialist = Specialist.where(id: params[:specialist_id])
        if specialist.present? && specialist.first.applied_projects.where(id: @project.id).present?
          s_id = params[:specialist_id].to_i
          @messages = @project.messages.business_specialist(b_id, s_id).page(params[:page]).per(20)
        end
      else
        s_id = @project.specialist_id
        @messages = @project.messages.business_specialist(b_id, s_id).page(params[:page]).per(20)
      end
    elsif current_specialist
      s_id = current_specialist.id
      b_id = @project.business_id
    end
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
    a = recipient
    if params[:specialist_id] && recipient.blank?
      specialist = Specialist.where(id: params[:specialist_id])
      recipient = specialist.first if specialist.present? && specialist.first.applied_projects.where(id: @project.id).present?
    end
    recipient = a if recipient.blank?
    @message = Message::Create.(@project, message_params.merge(sender: sender, recipient: recipient))
    respond_to do |format|
      format.js do
        render :new if @message.new_record?
      end
      format.html do
        alert = @message.new_record? ? @message.errors.messages.values.flatten.to_sentence : nil
        redirect_to path_after_create, alert: alert
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def render_messages
    render partial: 'messages/message',
           collection: @messages.map(&method(:decorate)).reverse,
           locals: { me: sender, them: recipient }
  end

  def message_params
    params.require(:message).permit(:message, :file)
  end

  def find_project
    project = sender.projects.where(id: params[:project_id])
    project = sender.applied_projects.where(id: params[:project_id]) if project.blank?
    @project = project.first if project.present?
  end
end
