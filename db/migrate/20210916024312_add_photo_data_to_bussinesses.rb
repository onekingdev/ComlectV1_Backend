class AddPhotoDataToBussinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :photo_data, :jsonb
  end
end
