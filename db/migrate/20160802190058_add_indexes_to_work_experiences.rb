# frozen_string_literal: true

class AddIndexesToWorkExperiences < ActiveRecord::Migration[6.0]
  def change
    add_index :work_experiences, :from
    add_index :work_experiences, :to
    add_index :work_experiences, :current
  end
end
