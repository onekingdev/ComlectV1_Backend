class AddIndexToRiskName < ActiveRecord::Migration[6.0]
  def change
    add_index :risks, :name
  end
end
