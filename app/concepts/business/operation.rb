# frozen_string_literal: true
class Business < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Business, :create

    contract do
      property :contact_first_name
      property :contact_last_name
      property :contact_email
      property :contact_job_title
      property :contact_phone
      property :business_name
      property :industry
      property :employees
      property :website
      property :linkedin_link
      property :description
      property :address_1
      property :address_2
      property :country
      property :city
      property :state
      property :zipcode
      property :anonymous

      validates :contact_first_name, :contact_last_name, :contact_email, presence: true
      validates :business_name, :industry, :employees, :description, presence: true
      validates :country, :city, :state, presence: true

      property :user do
        property :email
        property :password

        validates :email, presence: true
        validates :password, presence: true
      end
    end

    def process(params)
      validate params[:business], &:save
    end

    private

    def setup_model!(_params)
      model.build_user
    end
  end

  class Show < Trailblazer::Operation
    include Model
    model Business, :find

    # include Trailblazer::Operation::Policy
    # policy Business::Policy, :show?
  end
end
