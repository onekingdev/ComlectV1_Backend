# frozen_string_literal: true

class AddTokenToPortedBusiness < ActiveRecord::Migration
  def change
    add_column :ported_businesses, :token, :text
  end
end
