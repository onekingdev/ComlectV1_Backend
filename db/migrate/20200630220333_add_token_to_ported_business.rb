# frozen_string_literal: true

class AddTokenToPortedBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :ported_businesses, :token, :text
  end
end
