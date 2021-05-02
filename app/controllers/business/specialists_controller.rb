# frozen_string_literal: true

class Business::SpecialistsController < ApplicationController
  #before_action :authenticate_user!
  #before_action :require_business!

  #FILTERS = {
  #  'hired' => :hired,
  #  'favorited' => :favorited
  #}.freeze

  #def index
  #  @filter = FILTERS[params[:filter]] || :none
  #  @is_business_cards = request.original_fullpath.include?('business_cards')
  #  @specialists = current_business.filtered_specialists(@filter).page(params[:page]).per(6)
  #  respond_to do |format|
  #    format.html do
  #      if request.xhr?
  #        render partial: @is_business_cards ? 'specialists/business_cards' : 'specialists/cards',
  #               locals: {
  #                 specialists: @specialists,
  #                 remove_on_unfavorite: true,
  #                 hire_again: params[:filter] == 'hired'
  #               }
  #      end
  #    end
  #    format.js
  #  end
  #end

  include ActionView::Helpers::TagHelper

  before_action :require_business!
  before_action :set_cpolicy, only: %i[update edit show destroy ban unban]

  before_action :authenticate_user!
  before_action :require_business!

  def index
    render html: content_tag('business-marketplace-page', '').html_safe, layout: 'vue_business'
  end

end
