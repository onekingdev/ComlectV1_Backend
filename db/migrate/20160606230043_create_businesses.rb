# frozen_string_literal: true
class CreateBusinesses < ActiveRecord::Migration
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def change
    create_table :businesses do |t|
      t.references :user, index: true
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :contact_email
      t.string :contact_job_title
      t.string :contact_phone
      t.string :business_name
      t.string :industry
      t.string :employees
      t.string :website
      t.string :linkedin_link
      t.string :description
      t.string :address_1
      t.string :address_2
      t.string :country
      t.string :city
      t.string :state
      t.string :zipcode
      t.boolean :anonymous, null: false, default: true

      t.timestamps null: false
    end
    add_index :businesses, :anonymous
  end
end
