# frozen_string_literal: true

class AddLogoDataToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :logo_data, :jsonb
  end
end
