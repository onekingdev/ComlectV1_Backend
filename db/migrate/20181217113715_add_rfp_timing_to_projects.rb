# frozen_string_literal: true

class AddRfpTimingToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :rfp_timing, :string, default: nil
  end
end
