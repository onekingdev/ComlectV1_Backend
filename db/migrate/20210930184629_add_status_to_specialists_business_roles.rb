class AddStatusToSpecialistsBusinessRoles < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists_business_roles, :status, :string, default: 'active'
  end
end
