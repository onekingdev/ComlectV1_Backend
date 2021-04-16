# frozen_string_literal: true

class Api::Business::SpecialistsController < ApiController
  before_action :authenticate_user!
  before_action :require_business!

  FILTERS = {
    'hired' => :hired,
    'favorited' => :favorited
  }.freeze

  def index
    filter = FILTERS[params[:filter]] || :none
    specialists = paginate current_business.filtered_specialists(filter)
    respond_with specialists, each_serializer: ::Business::SpecialistSerializer
  end
end
