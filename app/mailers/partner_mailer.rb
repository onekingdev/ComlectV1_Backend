# frozen_string_literal: true

class PartnerMailer < ApplicationMailer
  # rubocop:disable Metrics/ParameterLists
  def ima_quote(full_name, email, company_name, number_of_employees, revenue, deductible, company_description)
    @full_name = full_name
    @email = email
    @company_name = company_name
    @number_of_employees = number_of_employees
    @revenue = revenue
    @deductible = deductible
    @company_description = company_description

    mail(
      to: 'wes.keating@signatureselect.com',
      subject: 'Complect E&O Referral for a Quote'
    )
  end
  # rubocop:enable Metrics/ParameterLists
end
