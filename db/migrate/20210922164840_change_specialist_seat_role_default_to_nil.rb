class ChangeSpecialistSeatRoleDefaultToNil < ActiveRecord::Migration[6.0]
  def up
    change_column_default :specialists, :seat_role, nil
  end

  def down
    change_column_default :specialists, :seat_role, 0
  end
end
