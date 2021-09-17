class AddNameSettingOnSpecialist < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :name_setting, :integer, limit: 1
  end
end
