class RenameWorkExperiencesDates < ActiveRecord::Migration[6.0]
  def change
    rename_column :work_experiences, :from, :start_date
    rename_column :work_experiences, :to, :end_date
  end
end
