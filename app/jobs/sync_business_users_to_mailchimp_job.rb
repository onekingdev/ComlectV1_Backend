class SyncBusinessUsersToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gibbon = Gibbon::Request.new
    puts ENV["MAILCHIMP_BUSINESS_ID"]
    gibbon.lists(ENV["MAILCHIMP_BUSINESS_LIST_ID"]).members.create(body: {
      email_address: user.contact_email,
      status: "subscribed",
      merge_fields: {
        FNAME: user.contact_first_name,
        LNAME: user.contact_last_name,
        COMPANY: user.business_name,
        STATE: user.state,
        PHONE: user.contact_phone,
        JURISDICT: user.jurisdictions.pluck(:name).join(', '),
        INDUSTRY: user.industries.pluck(:name).join(', ')
      }
    })
    # Every auto-synced business user should be tagged as "Businesses" HOW TO IMPLEMENT?
  end
end
