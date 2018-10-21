# frozen_string_literal: true

class SyncBusinesstWithMailChimpJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    business = args.first

    client = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    client.lists.subscribe(
      ENV['BUSINESS_MAILCHIMP_LIST'],
      {
        email: business.contact_email
      },
      business_additional_info(business),
      double_optin: false
    )
  end

  def business_additional_info(business)
    {
      FNAME: business.contact_first_name,
      LNAME: business.contact_last_name,
      ADDRESS: business.address_1,
      PHONE: business.contact_phone,
      MMERGE5: business.industries.map(&:name).join(', '),
      MMERGE6: business.contact_job_title,
      MMERGE7: business.business_name,
      STATE: business.state,
      MMERGE9: business.jurisdictions.map(&:name).join(', ')
    }
  end
end
