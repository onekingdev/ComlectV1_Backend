# frozen_string_literal: true

class AddSpecialistIdToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :specialist_id, :integer
  end
end
