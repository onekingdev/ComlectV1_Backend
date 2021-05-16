# frozen_string_literal: true

class Api::Business::SpecialistsController < ApiController
  before_action :authenticate_user!
  before_action :require_business!

  def index
    specialists = Specialist::Search.new(search_params).results
    respond_with specialists, each_serializer: ::Business::SpecialistSerializer
  end

  private

  def search_params
    params.permit(
      :keyword, :regulator, industry_ids: [], jurisdiction_ids: [], experience: [], min_hourly_rate: []
    )
  end
end
