class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.datetime :date
      t.string :currency
      t.integer :price
      t.string :stripe_invoice_id
      t.string :invoice_pdf
      t.string :stripe_charge_id
      t.string :stripe_customer_id
      t.string :name
      t.string :hosted_invoice_url
      t.string :invoice_type, default: 'plan'
      t.references :business, index: true
      t.references :specialist, index: true

      t.timestamps
    end
  end
end
