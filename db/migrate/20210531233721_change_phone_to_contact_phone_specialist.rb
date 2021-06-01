class ChangePhoneToContactPhoneSpecialist < ActiveRecord::Migration[6.0]
  def change
    rename_column :specialists, :phone, :contact_phone
  end
end
