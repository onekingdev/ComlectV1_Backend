# frozen_string_literal: true

class ProjectsFullTextIndex < ActiveRecord::Migration[6.0]
  def up
    add_column :projects, :tsv, :tsvector
    add_index :projects, :tsv, using: 'gin'

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON projects FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', title, description
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE projects SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate ON projects
    SQL

    remove_index :projects, :tsv
    remove_column :projects, :tsv
  end
end
