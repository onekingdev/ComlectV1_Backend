# frozen_string_literal: true

class Api::Business::SeatsController < ApiController
  before_action :require_business!
  skip_before_action :verify_authenticity_token

  def index
    respond_with current_business.all_employees, each_serializer: Business::SpecialistSerializer
  end
end
