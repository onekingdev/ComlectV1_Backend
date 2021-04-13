# frozen_string_literal: true

class Business::RisksController < ApplicationController
  include ActionView::Helpers::TagHelper
  before_action :authenticate_user!
  before_action :require_business!, only: %i[index show]

  def index
    render html: content_tag('business-risks-page', '').html_safe, layout: 'vue_business'
  end

  #def show
  #  render html: content_tag('business-risk-page', '').html_safe, layout: 'vue_business'
  #end

  def show
    render html: content_tag('business-risks-risk-detail', '', ':risk-id': params[:id]).html_safe, layout: 'vue_business'
  end

  private

  def set_risk
    @business = current_business
    @risk = current_business.risks.find(params[:id])
  end

end
