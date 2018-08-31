# frozen_string_literal: true

class AddHubspotCompanyIdToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :hubspot_company_id, :string
  end
end
