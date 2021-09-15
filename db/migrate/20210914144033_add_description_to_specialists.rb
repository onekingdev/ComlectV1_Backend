class AddDescriptionToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :description, :text
  end
end
