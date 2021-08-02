# frozen_string_literal: true

class Specialists::ProjectsController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_specialist!
  before_action :find_project, only: %i[show]

  FILTERS = {
    'active' => :active_projects,
    'pending' => :pending_projects,
    'favorited' => :favorited_projects,
    'complete' => :completed_projects
  }.freeze

  def index
    # render html: content_tag('my-projects-page', '').html_safe, layout: 'vue_specialist'
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_business_layout'
  end

  def show
    # @application = @project.job_applications.where(specialist_id: current_specialist.id).first
    # render html: content_tag('my-project-show-page',
    #                          '',
    #                          ':id': params[:id],
    #                          ':specialist-id': current_specialist.id,
    #                          'token': JsonWebToken.encode(sub: current_user.id),
    #                          ':application-id': @application.id).html_safe,
    #        layout: 'vue_specialist'

    @application = @project.job_applications.where(specialist_id: current_specialist.id).first
    render html: content_tag('main-layoyt',
                             '',
                             ':id': params[:id],
                             ':specialist-id': current_specialist.id,
                             'token': JsonWebToken.encode(sub: current_user.id),
                             ':application-id': @application.id).html_safe,
           layout: 'vue_business_layout_but_actually_specialist'
  end

  private

  def find_project
    projects = current_specialist.projects.where(id: params[:id])
    projects = current_specialist.applied_projects.where(id: params[:id]) if projects.blank?
    @project = projects.first
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
