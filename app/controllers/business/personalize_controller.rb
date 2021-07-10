# frozen_string_literal: true

# rubocop:disable all
class Business::PersonalizeController < ApplicationController
  before_action :require_business!

  def book
    respond_to do |format|
      format.json do
        if current_business
          @business = current_business
          @business.update(onboard_call_booked: true)
          render json: {url:"https://calendly.com/complect"}.to_json
        end
      end
    end
  end

  private

end
# rubocop:enable all
