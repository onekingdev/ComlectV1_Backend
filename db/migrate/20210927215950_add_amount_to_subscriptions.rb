class AddAmountToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :amount, :decimal
    add_column :subscriptions, :interval, :string
    add_column :subscriptions, :currency, :string
    add_column :subscriptions, :next_payment_date, :datetime
  end
end
