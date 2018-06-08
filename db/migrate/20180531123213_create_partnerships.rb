class CreatePartnerships < ActiveRecord::Migration
  def change
    create_table :partnerships do |t|
      t.string :company
      t.text :description
      t.string :discount
      t.string :discount_pub
      t.string :href
      t.jsonb :logo_data

      t.timestamps null: false
    end
  end
end
