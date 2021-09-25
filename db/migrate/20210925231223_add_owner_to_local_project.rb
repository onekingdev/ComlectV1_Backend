class AddOwnerToLocalProject < ActiveRecord::Migration[6.0]
  def up
    add_column :local_projects, :owner_type, :string
    add_column :local_projects, :owner_id, :integer
    LocalProject.find_each do |local_project|
      local_project.update_column('owner_type', "Business")
      local_project.update_column('owner_id', local_project.business_id)
    end
  end

  def down
    remove_column :local_projects, :owner_type
    remove_column :local_projects, :owner_id
  end
end
