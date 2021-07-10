# frozen_string_literal: true

class AddTutorialCompleteToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :tutorial_complete, :boolean, default: false
  end
end
