# frozen_string_literal: true

class IndexWorkExperienceCompliance < ActiveRecord::Migration
  def change
    add_index :work_experiences, :compliance
  end
end
