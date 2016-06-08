# frozen_string_literal: true
class AddLogoDataToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :logo_data, :jsonb
  end
end
