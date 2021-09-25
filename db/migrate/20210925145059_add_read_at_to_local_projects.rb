class AddReadAtToLocalProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :local_projects_specialists, :last_read_message_id, :integer, default: 0
    add_column :local_projects, :last_read_message_id, :integer, default: 0
    add_column :local_projects, :has_unread_messages, :boolean, default: false
  end
end
