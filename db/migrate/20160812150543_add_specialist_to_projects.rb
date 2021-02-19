# frozen_string_literal: true

class AddSpecialistToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :specialist, index: true
  end
end
