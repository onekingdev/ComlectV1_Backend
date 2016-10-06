# frozen_string_literal: true
class Specialists::NotificationSettingsController < ApplicationController
  before_action :require_specialist!

  def index
    @specialist = current_specialist
    @settings = Specialist.default_settings[:notifications]
  end

  def update
    setting = Specialist.default_settings[:notifications][params[:id]]
    return render_404 unless setting
    current_specialist.settings(:notifications).update_attributes! params[:id] => (params[:value] == 'true')
    render nothing: true, status: :ok
  end

  private

  def account_attributes
    params.require(:stripe_account).permit(
      :account_type, :account_country, :account_currency, :account_routing_number, :account_number, :address1,
      :postal_code, :city, :state, :country, :first_name, :last_name, :dob, :ssn_last_4, :personal_id_number,
      :verification_document, :accept_tos, :business_name, :business_tax_id
    ).merge(tos_acceptance_ip: request.remote_ip)
  end
end
