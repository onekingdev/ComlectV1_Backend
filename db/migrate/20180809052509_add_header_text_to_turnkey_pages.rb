# frozen_string_literal: true

class AddHeaderTextToTurnkeyPages < ActiveRecord::Migration
  def change
    add_column :turnkey_pages, :header_text, :string
  end
end
