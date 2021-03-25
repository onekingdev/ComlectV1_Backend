# frozen_string_literal: true

class AddHubspotCompanyIdToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :hubspot_company_id, :string
  end
end
