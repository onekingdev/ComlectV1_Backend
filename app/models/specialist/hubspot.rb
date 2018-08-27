# frozen_string_literal: true

class Specialist::Hubspot < HubspotContact
  def sync
    super
    sync_contact
  end

  private

  # rubocop:disable Rails/DynamicFindBy
  def hubspot_contact
    @hubspot_contact ||= Hubspot::Contact.find_by_id(object.hubspot_contact_id.to_i) if object.hubspot_contact_id.present?
    @hubspot_contact ||= Hubspot::Contact.create!(object.user.email)
  end
  # rubocop:enable Rails/DynamicFindBy

  # rubocop:disable Metrics/AbcSize
  def sync_contact
    hubspot_contact.update!(
      email: object.user.email,
      firstname: object.first_name,
      lastname: object.last_name,
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
  # rubocop:enable Metrics/AbcSize
end
