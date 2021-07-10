# frozen_string_literal: true

class AddSpecialistSubIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :sub_industries_specialist, :text, default: ''
  end
end
