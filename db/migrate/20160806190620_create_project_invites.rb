# frozen_string_literal: true
class CreateProjectInvites < ActiveRecord::Migration
  def change
    create_table :project_invites do |t|
      t.references :business, index: true, null: false
      t.references :project, index: true
      t.references :specialist, index: true, null: false
      t.string :message
      t.string :status, null: false, default: 'not_sent'

      t.timestamps null: false
    end
    add_index :project_invites, :status
  end
end
