# frozen_string_literal: true

class AddLatLngToSpecialists < ActiveRecord::Migration
  def change
    change_table :specialists do |t|
      t.decimal :lat, precision: 9, scale: 5
      t.decimal :lng, precision: 9, scale: 5
      t.column :point, :geography
    end

    add_index :specialists, :point, using: :gist

    reversible do |dir|
      dir.up do
        execute '
          CREATE TRIGGER trigger_specialists_on_lat_lng
          BEFORE INSERT OR UPDATE OF lat, lng ON specialists
          FOR EACH ROW
          EXECUTE PROCEDURE set_point_from_lat_lng()
        '
      end
      dir.down do
        execute 'DROP TRIGGER trigger_specialists_on_lat_lng ON specialists'
      end
    end
  end
end
