# frozen_string_literal: true

class BelongsToBusinessAnnualReport < ActiveRecord::Migration[6.0]
  def change
    add_column :annual_reports, :business_id, :integer, default: nil
  end
end
