# frozen_string_literal: true

class Specialists::ProjectsController < ApplicationController
  before_action :require_specialist!

  FILTERS = {
    'active' => :active_projects,
    'pending' => :pending_projects,
    'favorited' => :favorited_projects,
    'completed' => :completed_projects
  }.freeze

  def index
    @filter = FILTERS[filter_param]
    @projects = __send__(@filter || :render_404)
    @projects.map(&proc { |p| p.populate_rfp_specialist(current_specialist) })
    respond_to do |format|
      format.html do
        render partial: 'cards', locals: { projects: @projects }
      end
      format.js
    end
  end

  private

  def filter_param
    params.require(:filter)
  end

  def active_projects
    base_scope current_specialist.projects.active
  end

  def pending_projects
    base_scope current_specialist.applied_projects.visible
  end

  def favorited_projects
    base_scope current_specialist.favorited_projects.visible.pending
  end

  def completed_projects
    base_scope current_specialist.projects.complete
  end

  def base_scope(relation)
    relation.includes(:industries, :jurisdictions, :skills).recent # .page(params[:page]).per(6)
  end
end
