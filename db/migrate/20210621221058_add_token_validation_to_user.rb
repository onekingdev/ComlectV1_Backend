class AddTokenValidationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :jwt_hash, :string
  end
end
