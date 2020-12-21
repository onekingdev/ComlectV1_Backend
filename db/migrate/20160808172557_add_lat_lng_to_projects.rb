# frozen_string_literal: true

class AddLatLngToProjects < ActiveRecord::Migration[6.0]
  def change
    change_table :projects do |t|
      t.decimal :lat, precision: 9, scale: 5
      t.decimal :lng, precision: 9, scale: 5
      t.column :point, :geography
    end

    add_index :projects, :point, using: :gist

    reversible do |dir|
      dir.up do
        execute '
        CREATE TRIGGER trigger_projects_on_lat_lng
        BEFORE INSERT OR UPDATE OF lat, lng ON projects
        FOR EACH ROW
        EXECUTE PROCEDURE set_point_from_lat_lng()
      '
      end
      dir.down do
        execute 'DROP TRIGGER trigger_projects_on_lat_lng ON projects'
      end
    end
  end
end
