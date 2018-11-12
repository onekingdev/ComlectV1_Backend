class SyncSpecialistUsersToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    gibbon = Gibbon::Request.new
    # Build body of the specialists's information for the request
    body = {
      email_address: user.user.email,
      status: "subscribed",
      merge_fields: {
        FNAME: user.first_name,
        LNAME: user.last_name,
        PHONE: user.phone,
        STATE: user.state,
        JURISDICT: user.jurisdictions.pluck(:name).join(', '),
        INDUSTRY: user.industries.pluck(:name).join(', '),
        FORMERREG: user.former_regulator ? "Yes" : "No",
        YEARSEXP: user.years_of_experience
      }
    }
    #Execute the request
    begin
      gibbon.lists(ENV["MAILCHIMP_SPECIALIST_ID"]).members.create(body: body)
    rescue Gibbon::MailChimpError => exception
      puts exception
    end

    # Make a second call to add a a tag to the user
    begin
      gibbon.lists(ENV["MAILCHIMP_SPECIALIST_ID"]).members(Digest::MD5.hexdigest(user.user.email)).tags.create(
        body: {
          tags: [{name:"Specialists", status:"active"}]
        }
      )
    rescue Gibbon::MailChimpError => exception
      puts exception
    end
# VALIDATE CONTACT EMAIL
  end
end
