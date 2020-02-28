# frozen_string_literal: true

class AddBusinessFeeFreeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :business_fee_free, :boolean, default: false
  end
end
