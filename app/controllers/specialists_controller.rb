# frozen_string_literal: true
class SpecialistsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!

  FILTERS = {
    'all' => :all,
    'hired' => :hired,
    'shortlisted' => :shortlisted,
    'favourited' => :favourited
  }.freeze

  def index
    # TODO
    # filter = FILTERS[params[:filter]] || :none
    # @specialists = Specialist.cards_for_user(current_user, filter: filter, page: params[:page], per: params[:per])
    @specialists = Array.new(3)
    respond_to do |format|
      format.html do
        render partial: 'cards', specialists: @specialists if request.xhr?
      end
      format.js
    end
  end
end
