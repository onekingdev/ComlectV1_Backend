class DeleteFieldsFromSpecialistInvitations < ActiveRecord::Migration[6.0]
  def change
    remove_column :specialist_invitations, :email, :string
    remove_column :specialist_invitations, :first_name, :string
    remove_column :specialist_invitations, :last_name, :string
    remove_column :specialist_invitations, :role, :integer
  end
end
