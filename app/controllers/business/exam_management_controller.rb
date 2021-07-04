# frozen_string_literal: true

class Business::ExamManagementController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!

  def index
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  def show
    render html: content_tag('main-layoyt', '', ':exam-id': params[:id].to_i).html_safe, layout: 'vue_main_layout'
  end

  def portal
    render html: content_tag('business-exam-management-auditor-portal-show-page', '',
                             ':exam-id': params[:id].to_i).html_safe, layout: 'vue_onboarding'
  end
end
