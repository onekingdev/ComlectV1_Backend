# frozen_string_literal: true

class Specialist::Hubspot < HubspotContact
  def sync
    return if ENV['HUBSPOT_API_KEY'].blank?
    sync_contact
  end

  private

  def hubspot_contact
    @hubspot_contact ||= Hubspot::Contact.find_by(id: object.hubspot_contact_id.to_i) if object.hubspot_contact_id.present?
    begin
      @hubspot_contact ||= Hubspot::Contact.create!(object.user.email)
    rescue Hubspot::RequestError => e
      Rails.logger.fatal e.inspect
    end
    @hubspot_contact
  end

  def sync_contact
    hubspot_contact.update!(
      email: object.user.email,
      firstname: object.first_name,
      lastname: object.last_name,
      address: [object.address_1, object.address_2.presence].compact.join(', '),
      city: object.city,
      state: object.state,
      zip: object.zipcode,
      country: object.country,
      phone: object.phone,
      industry: object.industries.pluck(:name).join(', '),
      years_of_experience: object.years_of_experience,
      former_regulator: object.former_regulator?
    )

    object.update_columns(hubspot_contact_id: hubspot_contact.vid)
  end
end
