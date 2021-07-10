export class AccountInfoBusiness {
  constructor(apartment, aum, business_name, city, client_account_cnt, contact_first_name, contact_last_name, crd_number, id, industries, jurisdictions, state, sub_industries, username, address_1, address_2, contact_phone, website, zipcode) {
    this.apartment = apartment,
    this.aum = aum,
    this.business_name = business_name,
    this.city = city,
    this.client_account_cnt = client_account_cnt,
    this.contact_first_name = contact_first_name,
    this.contact_last_name = contact_last_name,
    this.crd_number = crd_number,
    this.id = id,
    this.industries = industries,
    this.jurisdictions = jurisdictions,
    this.state = state,
    this.sub_industries = sub_industries,
    this.username = username,
    this.address_1 = address_1,
    this.address_2 = address_2,
    this.contact_phone = contact_phone,
    this.website = website,
    this.zipcode = zipcode
  }
}

export class AccountInfoSpecialist {
  constructor(experience, first_name, former_regulator, id, industries, last_name, resume_url, skills, username) {
    this.experience = experience,
    this.first_name = first_name,
    this.former_regulator = former_regulator,
    this.id = id,
    this.industries = industries,
    this.last_name = last_name,
    this.resume_url = resume_url,
    this.skills = skills,
    this.username = username
  }
}
