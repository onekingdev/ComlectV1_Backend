# frozen_string_literal: true

class RenameBusinessSpecialistsRoles < ActiveRecord::Migration[6.0]
  def change
    rename_table :business_specialists_roles, :specialists_business_roles
  end
end
