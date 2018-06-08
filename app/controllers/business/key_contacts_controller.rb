# frozen_string_literal: true

class Business::KeyContactsController < ApplicationController
  before_action :require_business!

  def show
    @business = current_business
  end

  def update
    @business = current_business
    @saved = @business.update_attributes(contact_params)
    render :show
  end

  private

  def contact_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name, :contact_job_title, :contact_phone, :contact_email
    )
  end
end
