class AddQuantityToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :quantity, :integer
  end
end
