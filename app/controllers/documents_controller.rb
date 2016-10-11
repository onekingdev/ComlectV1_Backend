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

  def set_me
    @me = current_business_or_specialist
  end

  def find_project
    @project = current_business_or_specialist.projects.find(params[:project_id])
  end

  def sorted_documents
    all_documents = @project.messages.where.not(file_data: nil)
    all_documents = all_documents + @project.documents
    if params[:sort_by] == 'Name'
      if params['sort_direction'] == 'asc'
        all_documents = all_documents.sort{|a, b| a.get_file_name <=> b.get_file_name }
      else
        all_documents = all_documents.sort{|a, b| b.get_file_name <=> a.get_file_name }
      end
    elsif params[:sort_by] == 'Added By'
      if params['sort_direction'] == 'asc'
        all_documents = all_documents.sort{ |a, b| a.get_owner_name <=> b.get_owner_name }
      else
        all_documents = all_documents.sort{ |a, b| b.get_owner_name <=> a.get_owner_name }
      end
    else
      if params[:sort_by] == 'Date Added' && params['sort_direction'] == 'asc'
        all_documents = all_documents.sort{|a,b| a.created_at <=> b.created_at }
      else
        all_documents = all_documents.sort { |a,b| b.created_at <=> a.created_at }
      end
    end
    all_documents
  end

  def docs_of_current_page
    if params[:page].blank? || params[:page] == 1
      @docs_and_messages[0..10]
    elsif params[:page].present?
      @docs_and_messages[((params[:page].to_i - 1) * 10)..((params[:page].to_i) * 10)]
    end
  end

  def document_params
    params.require(:document).permit(:file)
  end

  def dashboard_redirection_based_on_role
    if current_business
      redirect_to business_project_dashboard_path(@project)
    elsif current_specialist
      redirect_to project_dashboard_path(@project)
    end
  end
end