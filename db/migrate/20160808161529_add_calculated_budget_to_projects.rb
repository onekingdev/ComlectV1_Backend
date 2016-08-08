# frozen_string_literal: true
class AddCalculatedBudgetToProjects < ActiveRecord::Migration
  # rubocop:disable Metrics/MethodLength
  def up
    add_column :projects, :calculated_budget, :decimal
    add_index :projects, :calculated_budget

    execute <<-SQL
      CREATE FUNCTION projects_calculate_budget() RETURNS trigger as $func$
      BEGIN
        IF NEW.type = 'full_time' THEN
          NEW.calculated_budget := NEW.annual_salary;
        ELSE
          IF NEW.pricing_type = 'hourly' THEN
            NEW.calculated_budget := NEW.hourly_rate;
          ELSE
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
  end

  def down
    execute "DROP TRIGGER calculate_budget ON projects"
    execute "DROP FUNCTION projects_calculate_budget()"
    remove_column :projects, :calculated_budget
  end
end
