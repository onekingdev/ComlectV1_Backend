# frozen_string_literal: true

class RemoveBusinessChangeFromAnnualReport < ActiveRecord::Migration[6.0]
  def change
    remove_column :annual_reports, :business_change
  end
end
