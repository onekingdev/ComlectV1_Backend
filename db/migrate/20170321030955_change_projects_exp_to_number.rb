# frozen_string_literal: true

class ChangeProjectsExpToNumber < ActiveRecord::Migration
  def up
    add_column :projects, :min_exp_int, :integer
    Project.select(:id, :minimum_experience).each do |project|
      project.update_attribute :min_exp_int, project.minimum_experience.split('-').first
    end
    remove_column :projects, :minimum_experience
    rename_column :projects, :min_exp_int, :minimum_experience
    add_index :projects, :minimum_experience
  end

  def down
    change_column :projects, :minimum_experience, :string
  end
end
