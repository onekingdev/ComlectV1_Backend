# frozen_string_literal: true

class Business::CompliancePoliciesController < ApplicationController
  include ActionView::Helpers::TagHelper

  before_action :require_business!
  before_action :set_cpolicy, only: %i[update edit show destroy ban unban]

  def index
    # render html: content_tag('business-policies-page', '').html_safe, layout: 'vue_business'
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  # def show
  #   render html: content_tag('business-policies-create-page', '', ':policy-id': params[:id]).html_safe, layout: 'vue_business'
  # end

  # def show
  #   render html: content_tag('business-policies-details-without-sections-page', '',
  #                            ':policy-id': params[:id]).html_safe, layout: 'vue_business'
  # end

  #def show
  #  render html: content_tag('business-policies-details-without-sections-page', '',
  #                           ':policy-id': params[:id]).html_safe, layout: 'vue_builder_layout'
  #end

  #def show
  #  render html: content_tag('builder-layoyt', '',
  #                           ':policy-id': params[:id]).html_safe, layout: 'vue_builder_layout'
  #end

  def show
    render html: content_tag('main-layoyt', '',
                             ':policy-id': params[:id]).html_safe, layout: 'vue_builder_layout'
  end

  def entire
    render html: content_tag('business-policies-entire-page', '').html_safe, layout: 'vue_business'
  end

  private

  def set_cpolicy
    @business = current_business
    @compliance_policy = current_business.compliance_policies.find(params[:id])
  end
end
