# frozen_string_literal: true

class SyncSpecialistUsersToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gibbon = Gibbon::Request.new
    body = {
      email_address: user.user.email,
      status: 'subscribed',
      merge_fields: {
        FNAME: user.first_name,
        LNAME: user.last_name,
        PHONE: user.phone,
        STATE: user.state,
        JURISDICT: user.jurisdictions.pluck(:name).join(', '),
        INDUSTRY: user.industries.pluck(:name).join(', '),
        FORMERREG: user.former_regulator ? 'Yes' : 'No',
        YEARSEXP: user.years_of_experience
      }
    }
    begin
      gibbon.lists(ENV['MAILCHIMP_SPECIALIST_ID']).members.create(body: body)
      add_tag_to_user(user.user.email)
    rescue Gibbon::MailChimpError => exception
      Rails.logger.info exception
    end
  end

  def add_tag_to_user(email)
    gibbon = Gibbon::Request.new
    gibbon.lists(ENV['MAILCHIMP_SPECIALIST_ID']).members(Digest::MD5.hexdigest(email)).tags.create(
      body: {
        tags: [{ name: 'Specialists', status: 'active' }]
      }
    )
  end
end
