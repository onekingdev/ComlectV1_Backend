# frozen_string_literal: true

class Api::Business::SpecialistsController < ApiController
  before_action :authenticate_user!
  before_action :require_business!

  def index
    # specialists = Specialist::Search.new(search_params).results
    specialists = paginate Specialist.where(specialist_team_id: nil)
    respond_with specialists, each_serializer: ::Business::SpecialistSerializer
  end

  private

  def search_params
    params.permit(
      :keyword, :regulator, skill_names: [],
                            industry_ids: [], jurisdiction_ids: [], experience: [], hourly_rate_range: []
    )
  end
end
