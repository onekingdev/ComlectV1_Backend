# frozen_string_literal: true

class AddCalculatedBudgetToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :calculated_budget, :decimal
    add_index :projects, :calculated_budget

    execute <<-SQL
      CREATE FUNCTION projects_calculate_budget() RETURNS trigger as $func$
      BEGIN
        IF NEW.type = 'full_time' THEN
          NEW.calculated_budget := NEW.annual_salary;
        ELSE
          IF NEW.pricing_type = 'hourly' AND NEW.hourly_rate IS NOT NULL AND NEW.estimated_hours IS NOT NULL THEN
            NEW.calculated_budget := NEW.hourly_rate * NEW.estimated_hours;
          ELSIF NEW.pricing_type = 'fixed' THEN
            NEW.calculated_budget := NEW.fixed_budget;
          END IF;
        END IF;
        RETURN NEW;
      END;
      $func$ LANGUAGE plpgsql
    SQL

    execute <<-SQL
      CREATE TRIGGER calculate_budget BEFORE INSERT OR UPDATE
      ON projects FOR EACH ROW EXECUTE PROCEDURE
      projects_calculate_budget();
    SQL

    execute <<-SQL
      UPDATE projects SET updated_at = NOW();
    SQL
  end

  def down
    execute 'DROP TRIGGER calculate_budget ON projects'
    execute 'DROP FUNCTION projects_calculate_budget()'
    remove_column :projects, :calculated_budget
  end
end
