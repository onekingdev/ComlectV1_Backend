# frozen_string_literal: true

class AddQnalvlToBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :qna_lvl, :integer, default: 0
  end
end
