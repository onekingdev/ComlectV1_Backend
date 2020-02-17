# frozen_string_literal: true

class SyncBusinessUsersToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gibbon = Gibbon::Request.new
    # Build body of the request for the businesses
    body = {
      email_address: user.contact_email,
      status: 'subscribed',
      merge_fields: {
        FNAME: user.contact_first_name,
        LNAME: user.contact_last_name,
        COMPANY: user.business_name,
        STATE: user.state,
        PHONE: user.contact_phone,
        JURISDICT: user.jurisdictions.pluck(:name).join(', '),
        INDUSTRY: user.industries.pluck(:name).join(', ')
      }
    }
    # Execute the request, to subscribe the user to the list
    begin
      gibbon.lists(ENV['MAILCHIMP_BUSINESS_ID']).members.create(body: body)
    rescue Gibbon::MailChimpError => exception
      Rails.logger.info exception
    end

    #  Make a second call to add a tag to the user
    begin
      gibbon.lists(ENV['MAILCHIMP_BUSINESS_ID']).members(Digest::MD5.hexdigest(user.user.email)).tags.create(
        body: {
          tags: [{ name: 'Businesses', status: 'active' }]
        }
      )
    rescue Gibbon::MailChimpError => exception
      Rails.logger.info exception
    end
  end
end
