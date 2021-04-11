# frozen_string_literal: true

class Api::BusinessesController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :require_business!, only: :update

  def show
    @business = Business.includes(:industries).find_by(username: params[:id])
  end

  def create
    business = Business.new(business_params)
    if business.save
      business.update_attribute('account_created', true)
      respond_with business, serializer: ::BusinessSerializer
    else
      respond_with errors: { business: business.errors.messages }
    end
  end

  def update
    business = current_business
    if business.update(edit_business_params)
      business.username = business.generate_username
      business.update(sub_industries: convert_sub_industries(params[:sub_industry_ids]))
      respond_with business, serializer: BusinessSerializer
    else
      respond_with errors: { business: business.errors.messages }
    end
  end

  private

  def convert_sub_industries(ids)
    return [] if ids.blank?
    tgt_industries = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      tgt_industries.push(Industry.find(c[0]).sub_industries.split("\r\n")[c[1]]) if current_business.industries.collect(&:id).include? c[0]
    end
    tgt_industries
  end

  def business_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name, :contact_email, :contact_job_title, :contact_phone,
      :business_name, :website, :aum, :apartment, :client_account_cnt,
      :address_1, :country, :city, :state, :zipcode, :crd_number,
      industry_ids: [], jurisdiction_ids: [],
      user_attributes: [
        :email, :password,
      ]
    )
  end

  def edit_business_params
    business_params.except(:user_attributes)
  end
end
