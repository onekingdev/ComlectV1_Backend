# frozen_string_literal: true

class AddToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :business_types_a, :string, default: nil
    add_column :businesses, :business_types_b, :string, default: nil
    add_column :businesses, :business_stages, :string, default: nil
    add_column :businesses, :business_risks, :string, default: nil
    add_column :businesses, :business_other, :string, default: nil
  end
end
