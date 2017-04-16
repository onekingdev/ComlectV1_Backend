# frozen_string_literal: true
class DocumentsController < ApplicationController
  before_action :find_project
  before_action :set_me

  # paths are absolute since this controller is inherited by other controllers
  def index
    @docs_and_messages = sorted_documents
    @show_docs = docs_of_current_page
    respond_to do |format|
      format.html do
        render partial: '/documents/viewer'
      end
      format.js do
        render '/documents/index'
      end
    end
  end

  def create
    @document = Document.create(document_params.merge(owner: @me, project: @project))
    dashboard_redirection_based_on_role
  end

  # This is rather unintuitive since it destroys both documents and files attached to messages
  def destroy
    if params[:doc_type] == 'Document'
      Document.find(params[:id]).destroy
    elsif params[:doc_type] == 'Message'
      m = Message.find(params[:id])
      m.file_data = nil
      m.save
    end
    dashboard_redirection_based_on_role
  end

  private

  # def recipient(project)
  #   current_business ? project.specialist : project.business
  # end

  def set_me
    @me = current_business_or_specialist
  end

  def find_project
    @project = current_business_or_specialist.projects.find(params[:project_id])
  end

  def sorted_documents
    all_documents = @project.messages.where.not(file_data: nil)
    all_documents += @project.documents
    sort_docs(all_documents, params['sort_direction'], params['sort_by'] || 'Date Added')
  end

  def docs_of_current_page
    current_page_num = params[:page].blank? ? 1 : params[:page].to_i
    @docs_and_messages[((current_page_num - 1) * 10)..(current_page_num * 10)]
  end

  def document_params
    params.require(:document).permit(:file)
  end

  def dashboard_redirection_based_on_role
    if current_business
      redirect_to business_project_dashboard_path(@project, anchor: 'nojump-project-documents')
    elsif current_specialist
      redirect_to project_dashboard_path(@project, anchor: 'nojump-project-documents')
    end
  end

  def sort_docs(all_documents, sort_direction, sort_keyword)
    sort_property = keyword_to_method(sort_keyword)
    if sort_direction == 'asc'
      all_documents.sort { |a, b| a.__send__(sort_property) <=> b.__send__(sort_property) }
    else
      all_documents.sort { |a, b| b.__send__(sort_property) <=> a.__send__(sort_property) }
    end
  end

  def keyword_to_method(keyword)
    case keyword
    when 'Name'
      :file_name
    when 'Date Added'
      :created_at
    when 'Added By'
      :owner_name
    end
  end
end
