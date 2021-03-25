# frozen_string_literal: true

class CreatePortedBusinesses < ActiveRecord::Migration
  def change
    create_table :ported_businesses do |t|
      t.string :company
      t.string :email

      t.timestamps null: false
    end
  end
end
