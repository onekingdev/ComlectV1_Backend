class AddBusinessIsCollaboratorToLocalProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :local_projects, :business_is_collaborator, :boolean, default: false
  end
end
