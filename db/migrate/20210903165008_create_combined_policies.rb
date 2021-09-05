class CreateCombinedPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :combined_policies do |t|
      t.integer :business_id
      t.jsonb :file_data

      t.timestamps
    end
  end
end
