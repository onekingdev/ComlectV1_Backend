class AddDmsMailedAtToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :dms_mailed_at, :datetime
    User.update_all(dms_mailed_at: Time.now)
  end

  def down
    remove_column :users, :dms_mailed_at
  end
end
