# frozen_string_literal: true

class AddPresonalizeToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :sec_or_crd, :string, default: nil
    add_column :businesses, :office_state, :string, default: nil
    add_column :businesses, :branch_offices, :boolean, default: nil
    add_column :businesses, :client_account_cnt, :int, default: nil
    add_column :businesses, :client_types, :string, default: nil
    add_column :businesses, :aum, :decimal, default: nil
    add_column :businesses, :cco, :string, default: nil
    add_column :businesses, :already_covered, :string, default: nil
    add_column :businesses, :review_plan, :string, default: nil
    add_column :businesses, :annual_compliance, :boolean, default: nil
    add_column :businesses, :already_covered_other, :string, default: nil
  end
end
