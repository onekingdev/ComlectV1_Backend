# frozen_string_literal: true

class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :name
      t.timestamps null: false
    end

    create_join_table :businesses, :industries
    add_index :businesses_industries, %i[business_id industry_id], unique: true
  end
end
