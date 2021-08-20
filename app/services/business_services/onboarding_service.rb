# frozen_string_literal: true

# Required fields
# ========
# business_name
# industry_ids
# jurisdiction_ids
# time_zone
# address_1
# city
# state
# zipcode

# Optional fields
# ===============
# sub_industry_ids
# apartment
# aum
# client_account_cnt
# contact_phone
# website

module BusinessServices
  class OnboardingService < ApplicationService
    attr_reader :business, :params

    def initialize(business, params)
      @business = business
      @params = params
      @success = true
    end

    def success?
      @success
    end

    def call
      assign_attributes

      unless business.save
        @success = false
      end

      self
    end

    private

    def assign_attributes
      business.assign_attributes(params)

      if business.username.blank? && business.business_name.present?
        business.username = business.generate_username
      end

      business.sub_industries = convert_sub_industries
    end

    def convert_sub_industries
      ids = params[:sub_industry_ids]
      return [] if ids.blank?

      tgt_industries = []
      ids.each do |sub_ind|
        c = sub_ind.split('_').map(&:to_i)

        if business.industries.collect(&:id).include?(c[0])
          tgt_industries.push(Industry.find(c[0]).sub_industries.split("\r\n")[c[1]])
        end
      end

      tgt_industries
    end
  end
end
