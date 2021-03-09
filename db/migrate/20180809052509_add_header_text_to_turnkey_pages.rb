# frozen_string_literal: true

class AddHeaderTextToTurnkeyPages < ActiveRecord::Migration[6.0]
  def change
    add_column :turnkey_pages, :header_text, :string
  end
end
