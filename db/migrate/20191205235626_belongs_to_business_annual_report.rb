# frozen_string_literal: true

class BelongsToBusinessAnnualReport < ActiveRecord::Migration
  def change
    add_column :annual_reports, :business_id, :integer, default: nil
  end
end
