# frozen_string_literal: true

class CreatePotentialBusinesses < ActiveRecord::Migration[6.0]
  def change
    create_table :potential_businesses do |t|
      t.string :crd_number, unique: true, index: true
      t.string :contact_phone
      t.string :business_name
      t.string :website
      t.string :address_1
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :apartment
      t.integer :client_account_cnt
      t.decimal :aum

      t.timestamps null: false
    end
  end
end
