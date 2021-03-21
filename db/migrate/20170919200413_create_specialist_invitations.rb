# frozen_string_literal: true

class CreateSpecialistInvitations < ActiveRecord::Migration[6.0]
  def change
    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table :specialist_invitations do |t|
      t.belongs_to :specialist_team, null: false, index: true
      t.belongs_to :specialist

      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :token, null: false, index: true
      t.integer :status, null: false, default: 0
    end
    # rubocop:enable Rails/CreateTableWithTimestamps
  end
end
