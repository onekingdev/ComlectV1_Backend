# frozen_string_literal: true

class Business::Hubspot < HubspotContact
  def sync
    super
    sync_company
    sync_contact
  end

  private

  # rubocop:disable Rails/DynamicFindBy
  def hubspot_company
    @hubspot_company ||= Hubspot::Company.find_by_id(object.hubspot_company_id.to_i) if object.hubspot_company_id.present?
    @hubspot_company ||= Hubspot::Company.create!(object.business_name)
  end

  def hubspot_contact
    @hubspot_contact ||= Hubspot::Contact.find_by_id(object.hubspot_contact_id.to_i) if object.hubspot_contact_id.present?
    @hubspot_contact ||= Hubspot::Contact.create!(object.user.email)
  end
  # rubocop:enable Rails/DynamicFindBy

  def sync_company
    hubspot_company.update!(
      description: object.description,
      website: object.website
    )

    object.update_columns(hubspot_company_id: hubspot_company.vid)
  end

  def sync_contact
    hubspot_contact.update!(
      email: object.user.email,
      firstname: object.contact_first_name,
      lastname: object.contact_last_name,
      city: object.city,
      state: object.state,
      zip: object.zipcode,
      country: object.country,
      phone: object.contact_phone
    )

    object.update_columns(hubspot_contact_id: hubspot_contact.vid)

    hubspot_company.add_contact(hubspot_contact)
  end
end
