# frozen_string_literal: true

class AddTutorialCompleteToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :tutorial_complete, :boolean, default: false
  end
end
