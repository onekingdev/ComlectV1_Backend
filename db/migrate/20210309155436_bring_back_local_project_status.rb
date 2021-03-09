# frozen_string_literal: true

class BringBackLocalProjectStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :local_projects, :status, :string, default: 'inprogress'
  end
end
