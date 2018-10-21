# frozen_string_literal: true

class SyncSpecialistWithMailChimpJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    specialist = args.first
    user = User.find(specialist.user_id)

    client = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    client.lists.subscribe(
      ENV['SPECIALIST_MAILCHIMP_LIST'],
      {
        email: user.email
      },
      specialist_additional_info(specialist),
      double_optin: false
    )
  end

  def specialist_additional_info(specialist)
    {
      FNAME: specialist.first_name,
      LNAME: specialist.last_name,
      ADDRESS: specialist.address_1,
      PHONE: specialist.phone,
      MMERGE5: specialist.former_regulator.to_s,
      MMERGE6: specialist.industries.map(&:name).join(', '),
      MMERGE7: specialist.years_of_compilant_experience,
      STATE: specialist.state,
      MMERGE9: specialist.jurisdictions.map(&:name).join(', ')
    }
  end
end
