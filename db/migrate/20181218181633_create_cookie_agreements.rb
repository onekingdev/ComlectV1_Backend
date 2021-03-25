# frozen_string_literal: true

class CreateCookieAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :cookie_agreements do |t|
      t.datetime :agreement_date
      t.string :cookie_description
      t.boolean :status
      t.string :ip_address
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
