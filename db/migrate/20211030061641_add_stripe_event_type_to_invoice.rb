class AddStripeEventTypeToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :stripe_event_type, :string, default: 'charge'
    add_column :invoices, :stripe_transfer_id, :string
  end
end
