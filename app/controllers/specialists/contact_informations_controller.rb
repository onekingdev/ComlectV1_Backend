# frozen_string_literal: true

class Specialists::ContactInformationsController < ApplicationController
  before_action :require_specialist!

  def show
    @specialist = Specialist::Form.for_user(current_user)
  end

  def update
    @specialist = Specialist::Form.for_user(current_user)
    @specialist.assign_attributes(specialist_params)
    @saved = @specialist.save
    render :show
  end

  private

  def specialist_params
    params.require(:specialist).permit(
      :first_name,
      :last_name,
      :contact_phone,
      :linkedin_link,
      user_attributes: %i[id email]
    )
  end
end
