# frozen_string_literal: true

class AddStartsEndsIn4824NotificationsToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :starts_in_48, :boolean, default: false
    add_column :projects, :ends_in_24, :boolean, default: false
  end
end
