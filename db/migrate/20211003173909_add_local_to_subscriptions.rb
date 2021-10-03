class AddLocalToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :local, :boolean, default: false
  end
end
