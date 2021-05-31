# frozen_string_literal: true

class Api::Settings::BusinessController < ApiController
    before_action :require_business!

    def index
      respond_with @current_business, serializer: BusinessSerializer
    end

    def update
      if @current_business.update(general_params)
        respond_with @current_business, serializer: BusinessSerializer, status: :ok
      else
        respond_with errors: @current_business.errors, status: :unprocessable_entity
      end
    end

    private

    def business_params
      params.require(:business).permit(
        :contact_first_name, :contact_last_name, :contact_email, :contact_job_title, :contact_phone,
        :business_name, :website, :aum, :apartment, :client_account_cnt, :logo, :time_zone,
        :address_1, :country, :city, :state, :zipcode, :crd_number, sub_industry_ids: [],
        industry_ids: [], jurisdiction_ids: []
      )
    end
  end