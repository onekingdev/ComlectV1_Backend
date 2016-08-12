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
    @projects = __send__(FILTERS[filter_param] || :render_404)
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
    base_scope Project.none # TODO
  end

  def pending_projects
    base_scope Project.none # TODO
  end

  def favorited_projects
    base_scope current_specialist.favorited_projects
  end

  def completed_projects
    base_scope Project.none # TODO
  end

  def base_scope(relation)
    relation.includes(:industries, :jurisdictions, :skills).page(params[:page]).per(6)
  end
end
