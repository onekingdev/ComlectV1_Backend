# frozen_string_literal: true
class Business::JobApplicationsController < ApplicationController
  before_action :require_business!

  def index
    @project = current_business.projects.preload_associations.find(params[:project_id])
    respond_to do |format|
      format.html do
        if request.xhr?
          @specialists = Specialist::Search.new(search_params).results
          # @specialists = Specialist.preload_associations # TODO: Filter/sort
          render partial: 'cards', specialists: @specialists
        end
      end
    end
  end

  private

  def search_params
    { sort_by: params[:sort_by] }
  end
end
