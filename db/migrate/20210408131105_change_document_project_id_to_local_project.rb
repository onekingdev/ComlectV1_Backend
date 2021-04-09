# frozen_string_literal: true

class ChangeDocumentProjectIdToLocalProject < ActiveRecord::Migration[6.0]
  def up
    rename_column :documents, :project_id, :local_project_id
    Document.all.each do |doc|
      proj = Project.where(id: doc.local_project_id)
      local_project = nil
      if proj.count.positive?
        proj = proj.first
        if proj.local_project.blank?
          local_project_params = proj.attributes.slice('business_id', 'title', 'description', 'starts_on', 'ends_on')
          local_project = LocalProject.create(local_project_params)
          proj.update(local_project_id: local_project.id)
        end
      end
      doc.update(local_project_id: local_project.id) unless local_project.nil?
    end
  end

  def down
    Document.all.each do |doc|
      next if doc.local_project.blank?
      doc.update(local_project_id: doc.local_project.projects[0].id) if doc.local_project.projects.present?
    end
    rename_column :documents, :local_project_id, :project_id
  end
end
