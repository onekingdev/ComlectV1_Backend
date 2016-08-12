# frozen_string_literal: true
class Business::SpecialistsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!

  FILTERS = {
    'hired' => :hired,
    'favorited' => :favorited
  }.freeze

  def index
    @specialists = current_business.filtered_specialists(FILTERS[params[:filter]] || :none).page(params[:page]).per(6)
    respond_to do |format|
      format.html do
        render partial: 'specialists/cards',
               locals: {
                 specialists: @specialists,
                 remove_on_unfavorite: true
               } if request.xhr?
      end
      format.js
    end
  end
end
