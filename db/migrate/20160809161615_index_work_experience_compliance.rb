# frozen_string_literal: true

class IndexWorkExperienceCompliance < ActiveRecord::Migration[6.0]
  def change
    add_index :work_experiences, :compliance
  end
end
