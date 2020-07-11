# frozen_string_literal: true

class Specialists::ProjectsController < ApplicationController
  before_action :require_specialist!
  before_action :redirect_to_employee

  FILTERS = {
    'active' => :active_projects,
    'pending' => :pending_projects,
    'favorited' => :favorited_projects,
    'complete' => :completed_projects
  }.freeze

  def index
    @filter = FILTERS[params[:filter]] || :none
    if @filter != :none
      @projects = __send__(@filter || :render_404)
      @projects.map(&proc { |p| p.populate_rfp_specialist(current_specialist) })
    end
    @is_specialist_cards = request.original_fullpath.include?('specialist_cards')
    @ratings = current_specialist.ratings_combined

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: @is_specialist_cards ? 'business/projects/business_cards' : 'cards', locals: { projects: @projects }
        end
      end
      format.js
    end
  end

  private

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
