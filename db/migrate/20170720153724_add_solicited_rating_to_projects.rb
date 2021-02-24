# frozen_string_literal: true

class AddSolicitedRatingToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :solicited_business_rating, :boolean, default: false
    add_column :projects, :solicited_specialist_rating, :boolean, default: false
  end
end
