# frozen_string_literal: true

class AddReadToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read_by_recipient, :boolean, default: false
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE messages SET read_by_recipient = TRUE WHERE read_by_recipient = FALSE;
        SQL
      end
    end
  end
end
