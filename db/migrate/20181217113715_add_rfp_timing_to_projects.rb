# frozen_string_literal: true

class AddRfpTimingToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :rfp_timing, :string, default: nil
  end
end
