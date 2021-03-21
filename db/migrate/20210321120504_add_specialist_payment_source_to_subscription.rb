class AddSpecialistPaymentSourceToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_reference :subscriptions, :specialist_payment_source, null: true, foreign_key: true
  end
end
