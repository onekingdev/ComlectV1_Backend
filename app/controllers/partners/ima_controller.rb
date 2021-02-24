# frozen_string_literal: true

class Partners::ImaController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def create
    PartnerMailer.deliver_later(
      :ima_quote,
      "#{ima_params[:first_name]} #{ima_params[:last_name]}",
      current_user.email,
      ima_params[:company_name],
      ima_params[:number_of_employees],
      ima_params[:revenue],
      ima_params[:deductible],
      ima_params[:company_description]
    )

    redirect_to partners_ima_index_path, notice: 'Quote request submitted'
  end

  private

  def ima_params
    params.require(:ima).permit(
      :first_name,
      :last_name,
      :company_name,
      :number_of_employees,
      :revenue,
      :deductible,
      :company_description
    )
  end
end
