# frozen_string_literal: true

class AddSpecialistToProjects < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :specialist, index: true
  end
end
