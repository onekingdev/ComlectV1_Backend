# frozen_string_literal: true
class Business::ProjectRatingsController < ::ProjectRatingsController
  prepend_before_action :require_business!

  private

  def set_form_url
    @form_url = business_project_rating_path(@project.id) if @project
  end

  def redirect_url
    business_project_dashboard_path @project
  end

  def specialist_or_business
    current_business
  end

  def find_project
    @project = current_business.projects.pending_business_rating.find_by(id: params[:project_id])
    render js: '' unless @project
  end
end
