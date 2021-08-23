# frozen_string_literal: true

class Api::Business::SeatsController < ApiController
  before_action :require_business!
  skip_before_action :verify_authenticity_token

  def available_seat_count
    render json: { count: current_business.seats.available.count }, status: :ok
  end
end
