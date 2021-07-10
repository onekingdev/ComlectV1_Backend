# frozen_string_literal: true

class CreateTosAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :tos_agreements do |t|
      t.datetime :agreement_date
      t.string :description
      t.boolean :status
      t.string :ip_address
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
