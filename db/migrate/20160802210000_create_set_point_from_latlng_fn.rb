# frozen_string_literal: true

class CreateSetPointFromLatlngFn < ActiveRecord::Migration[6.0]
  def up
    execute '
      CREATE OR REPLACE FUNCTION set_point_from_lat_lng() RETURNS trigger AS $func$
      BEGIN
        NEW.point := ST_SetSRID(ST_Point(NEW.lng, NEW.lat), 4326);
        RETURN NEW;
      END;
      $func$ LANGUAGE plpgsql
    '
  end

  def down
    execute 'DROP FUNCTION set_point_from_lat_lng()'
  end
end
