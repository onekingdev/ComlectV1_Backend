class AddCategoryToPartnership < ActiveRecord::Migration
  def change
    add_column :partnerships, :category, :string
  end
end
