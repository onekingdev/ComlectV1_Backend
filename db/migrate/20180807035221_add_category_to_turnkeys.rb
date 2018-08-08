# frozen_string_literal: true

class AddCategoryToTurnkeys < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :turnkey_page_id, :integer
  end
end
