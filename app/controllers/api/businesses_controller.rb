# frozen_string_literal: true

class Api::BusinessesController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :require_business!, only: :update

  def create
    business = Business.new(business_params)
    if business.save
      business.update_attribute('account_created', true)
      BusinessMailer.verify_email(business.user, business.user.otp).deliver_later
      render json: { userid: business.user_id, message: 'You have received one time passcode to confirm your email' }.to_json
    else
      respond_with errors: { business: business.errors.messages }
    end
  end

  def update
    if edit_business_params.has_key?('crd_number')
      build_business
      respond_with current_business, serializer: BusinessSerializer
    else
      if current_business.update(edit_business_params)
        current_business.username = current_business.generate_username
        current_business.update(sub_industries: convert_sub_industries(params[:sub_industry_ids]))
        respond_with current_business, serializer: BusinessSerializer
      else
        respond_with errors: { business: current_business.errors.messages }
      end
    end
  end

  private

  def convert_sub_industries(ids)
    return [] if ids.blank?
    tgt_industries = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      if current_business.industries.collect(&:id).include? c[0]
        tgt_industries.push(Industry.find(c[0]).sub_industries.split("\r\n")[c[1]])
      end
    end
    tgt_industries
  end

  def business_params
    params.require(:business).permit(
      :contact_first_name, :contact_last_name, :contact_email, :contact_job_title, :contact_phone,
      :business_name, :website, :aum, :apartment, :client_account_cnt, :logo,
      :address_1, :country, :city, :state, :zipcode, :crd_number,
      industry_ids: [], jurisdiction_ids: [],
      user_attributes: %i[
        email password
      ]
    )
  end

  def edit_business_params
    business_params.except(:user_attributes)
  end

  def build_business
    potential_business = PotentialBusiness.find_by(crd_number: edit_business_params[:crd_number])
    if potential_business
      business_attrs = potential_business.attributes.except('id', 'created_at', 'updated_at')
      current_business.assign_attributes(business_attrs)
      current_business.save(validate: false)
    else
      current_business.update_attribute('crd_number', edit_business_params[:crd_number])
    end
  end
end
