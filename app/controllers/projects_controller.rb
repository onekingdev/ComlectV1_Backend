# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ActionView::Helpers::TagHelper

  prepend_before_action :authenticate_user!
  before_action :require_specialist!

  def index
    render html: content_tag('project-index-page', '').html_safe, layout: 'vue_specialist'
  end

  def show
    @project = policy_scope(Project).find(params[:id])
  end
end
