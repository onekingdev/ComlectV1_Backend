# frozen_string_literal: true

class Projects::JobApplicationsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_specialist!, except: 'show'
  before_action :find_project

  def show
    @job_application = JobApplication::Form.find(params[:id])
    render :new
  end

  def new
    render html: content_tag('create-proposal-page',
                             '',
                             ':project-id' => @project.id,
                             ':project': @project.to_json).html_safe, layout: 'vue_specialist'
  end

  def edit
    @job_application = JobApplication::Form.find(params[:id])
    render :new
  end

  def update
    @job_application = JobApplication::Form.find(params[:id])
    if @project.rfp? && @job_application.update(job_application_params)
      redirect_to @project
    else
      render :new
    end
  end

  def create
    @job_application = JobApplication::Form.apply!(
      current_specialist,
      @project,
      job_application_params
    )

    if @job_application.persisted?
      if @job_application.draft?
        redirect_to specialists_dashboard_path(anchor: 'projects-pending')
      else
        respond_to do |format|
          format.js { js_redirect project_path(@project) }
          format.html { redirect_to project_path(@project) }
        end
      end
    else
      render :new
    end
  end

  def destroy
    @job_application = current_specialist.job_applications.find_by(id: params[:id])
    return render_404 unless @job_application
    authorize @job_application, :destroy?
    JobApplication::Delete.call(@job_application)
    respond_to do |format|
      format.js { js_redirect params[:redirect_to] || project_path(@project) }
      format.html { redirect_to params[:redirect_to] || project_path(@project) }
    end
  end

  private

  def job_application_params
    params.require(:job_application).permit(
      :message,
      :key_deliverables,
      :pricing_type,
      :starts_on,
      :ends_on,
      :hourly_payment_schedule,
      :fixed_payment_schedule,
      :hourly_rate,
      :fixed_budget,
      :estimated_hours,
      :status,
      :fixed_budget
    )
  end

  def find_project
    @project = Project.published.pending.find(params[:project_id])
  end
end
