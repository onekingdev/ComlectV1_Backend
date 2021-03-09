# frozen_string_literal: true

class AddSpecialistSubIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :sub_industries_specialist, :text, default: ''
  end
end
